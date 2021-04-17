//
//  Error+Extension.swift
//  WatchTogether
//
//  Created by emin on 12.04.2021.
//

import Foundation

extension Error {
    var presentableError: PresentableError {
        return PresentableError(message: self.localizedDescription)
    }
}

