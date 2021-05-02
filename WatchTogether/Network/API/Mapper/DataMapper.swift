//
//  DataMapper.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Moya
import Alamofire

struct DataMapper {
        
    public static func map<T: Decodable>(_ result: Result<Response, MoyaError>) -> Result<T, PresentableError> {
        
        switch result {
        case .success(let response):
           
            do {
                let apiResponse = try response.map( T.self )
                return .success(apiResponse)
                
            } catch {
                return .failure(PresentableError(message: error.localizedDescription))
            }

        case .failure(let error):
            return .failure(PresentableError(message: error.errorDescription ?? error.localizedDescription))
        }
        
    }
}
