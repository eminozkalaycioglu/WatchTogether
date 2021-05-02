//
//  NetworkAdapter.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Moya
import Alamofire

struct NetworkAdapter {
    
    private static let session: Alamofire.Session = {
        let session = Alamofire.Session(configuration: .default, startRequestsImmediately: false)
        return session
    }()
        
    private static let provider = MoyaProvider<MultiTarget>(session: session)
    
    @discardableResult
    public static func request(target: TargetType,
                               completion: @escaping (Result<Response, MoyaError>) -> Void,
                               progress: ProgressBlock? = nil ) -> Cancellable  {
        
        provider.request(MultiTarget(target), callbackQueue: nil, progress: progress) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
