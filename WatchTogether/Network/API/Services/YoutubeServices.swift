//
//  YoutubeServices.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Moya

protocol YoutubeServicing {
    func getVideoDetail(_ videoId: String, completion: @escaping (Result<VideoDetail, PresentableError>) -> Void )
}

extension YoutubeServicing {
    
    func getVideoDetail(_ videoId: String, completion: @escaping (Result<VideoDetail, PresentableError>) -> Void ) {
        NetworkAdapter.request(target: YoutubeAPI.video(videoId) ) { result in
            completion( DataMapper.map(result) )
        }
    }
}

struct YoutubeServices: YoutubeServicing {}
