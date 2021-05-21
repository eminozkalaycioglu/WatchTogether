//
//  VideoDetail.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation

struct VideoDetail: Codable {

    let items: [Item]
    
    var toVideo: Video {
        let item = self.items.first
        let video = Video(
            videoId: item?.id,
            title: item?.snippet.title,
            thumbnail: item?.snippet.thumbnails.defaultField.url,
            channel: item?.snippet.channelTitle,
            sendTime: DateFormatter.wtDateFormatter.string(from: Date()))
        
        return video
    }
    
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
        case defaultField = "medium"
    }

}

struct Default: Codable {

    let url: String
}

