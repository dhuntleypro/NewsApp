//
//  Article.swift
//  NewsApp
//
//  Created by Darrien Huntley on 2/25/22.
//

import Foundation

struct Article: Codable {
    let source : Source
    let title : String
    let description: String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String
}

struct Source: Codable {
    let name : String
}
