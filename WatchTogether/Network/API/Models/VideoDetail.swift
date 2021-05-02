//
//  VideoDetail.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation

struct VideoDetail: Codable {

    let items: [Item]
    
}

struct Item: Codable {

    let id: String
    let snippet: Snippet
}

struct Snippet: Codable {

    let channelTitle: String
    let publishedAt: String
    let thumbnails: Thumbnail
    let title: String

}

struct Thumbnail: Codable {

    let defaultField: Default

    enum CodingKeys: String, CodingKey {
        case defaultField = "default"
    }

}

struct Default: Codable {

    let url: String
}

