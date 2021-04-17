//
//  PresentableError.swift
//  WatchTogether
//
//  Created by emin on 12.04.2021.
//

import Foundation

class PresentableError: Error {
    let message: String
    
    init(message: String) {
        self.message = message
    }
}
