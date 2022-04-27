//
//  NewsService.swift
//  News Room
//
//  Created by Pinaki Bandyopadhyay on 03/02/1401 AP.
//  Copyright © 1401 AP Pinaki Bandyopadhyay. All rights reserved.
//

import Foundation

protocol AppCallerDelegate {
    func didUpdateNews(_ newsService: APICaller, news: NewsData)
    func didFailWithError(error: Error)
}

class APICaller {
    
    let newsURL = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apikey=55c23c9f979d46e5bade55a65afca43b"
    
    var delegate: AppCallerDelegate?
    
    func performRequest(){
        
        //1. Create a URL - guard let is used to print error
        guard let url = URL(string: newsURL) else {
            print("Can't able to get news URL")
            return
        }
        //2. Create A URLSession
        //3. Give URLSession a task
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let newsData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateNews(self, news: newsData)
                    }
                }
            }
            //4. Start the task
            task.resume()
        
    }
    
    func parseJSON(_ newsData: Data) -> NewsData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsData.self, from: newsData)            
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
