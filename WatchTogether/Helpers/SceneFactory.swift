//
//  SceneFactory.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

final class SceneFactory {
    
    public static func makeViewController() -> TestViewController {
        let viewController = TestViewController()
        return viewController
    }
    
}

typealias SF = SceneFactory
