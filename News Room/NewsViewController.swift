//
//  ViewController.swift
//  News Room
//
//  Created by Pinaki Bandyopadhyay on 02/02/1401 AP.
//  Copyright © 1401 AP Pinaki Bandyopadhyay. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var newsService = NewsService()
    
    var newsData: NewsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        newsService.delegate = self
        newsService.performRequest()       
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    //MARK: - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.articles.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        cell.label.text = newsData?.articles[indexPath.row].description
        
        if let imageURL =  newsData?.articles[indexPath.row].urlToImage {
           //1. Create a URL
           if let url = URL(string: imageURL){
               
               //2. Create A URLSession
               let session = URLSession(configuration: .default)
               
               //3. Give URLSession a task
               let task = session.dataTask(with: url) { (data, response, error) in
                   if error != nil {
                       print(error!)
                       return
                   }
                   if let safeData = data {
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: safeData)
                    }
                   }
               }
               //4. Start the task
               task.resume()
           }
        }
        return cell
    }
}

//MARK: - NewsService Delegate Methods

extension NewsViewController: NewsServiceDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateNews(_ newsService: NewsService, news: NewsData) {
        DispatchQueue.main.async {
            self.newsData = news
            self.tableView.reloadData()
        }
    }
}

