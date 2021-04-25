//
//  UIImage+Extensions.swift
//  WatchTogether
//
//  Created by emin on 23.04.2021.
//

import Foundation
import UIKit

extension UIImage {
    static func avatar(id: Int) -> UIImage? {
        UIImage(named: "avatar_\(id)")
    }
}
