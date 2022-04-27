//
//  NewsData.swift
//  News Room
//
//  Created by Pinaki Bandyopadhyay on 03/02/1401 AP.
//  Copyright © 1401 AP Pinaki Bandyopadhyay. All rights reserved.
//

import Foundation

struct NewsData: Decodable {
    let articles: [Articles]
}

struct Articles: Decodable {
    let title: String
    let urlToImage: String
}
