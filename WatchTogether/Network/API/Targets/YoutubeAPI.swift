//
//  YoutubeAPI.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation
import Moya

enum YoutubeAPI {
    case video(String)
}

// https://www.googleapis.com/youtube/v3/videos?part=snippet&id=7fYi_tYZhnY&key=AIzaSyDQ6vMN1j-LtHE6JDr0WQEvr2pBkPT7AlQ
extension YoutubeAPI: TargetType {
    
    var apiKey: String {
        "AIzaSyDQ6vMN1j-LtHE6JDr0WQEvr2pBkPT7AlQ"
    }
    
    var sampleData: Data {
        Data()
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var baseURL: URL { URL(string: "https://www.googleapis.com/youtube/v3/videos")! }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method { .get }
    
    var task: Task {
        switch self {
        case let .video(videoId):
            return .requestParameters(parameters: [
                "part": "snippet",
                "id": videoId,
                "key": self.apiKey
            ], encoding: URLEncoding.default)
        
            
        }
        
    }
}
