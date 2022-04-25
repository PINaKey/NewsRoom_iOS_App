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
            //Create URL
            let url = URL(fileURLWithPath: imageURL)
            
            //Fetch Image Data
            if let data = try? Data(contentsOf: url){
                //Create Image and update image view
                 cell.newsImageView.image = UIImage(data: data)
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

