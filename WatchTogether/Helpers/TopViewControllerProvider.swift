//
//  TopViewControllerProvider.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

protocol TopViewControllerProvider {
    var topViewController: UIViewController? { get }
}

typealias RootViewControllerProvider = () -> UIViewController?

final class DefaultTopViewControllerProvider: TopViewControllerProvider {
    private let rootViewControllerProvider: RootViewControllerProvider

    init(rootViewControllerProvider: @escaping RootViewControllerProvider = { UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController }) {
        self.rootViewControllerProvider = rootViewControllerProvider
    }

    var topViewController: UIViewController? {
        guard let root = self.rootViewControllerProvider() else { return nil }
        return self.traverseViewControllersHierarchy(startingFrom: root)
    }

    private func traverseViewControllersHierarchy(startingFrom root: UIViewController) -> UIViewController? {
        var currentViewController: UIViewController? = root
        while currentViewController != nil {
            if let customContainer = currentViewController as? TopViewControllerProvider {
                currentViewController = customContainer.topViewController
            } else if let presentedController = currentViewController?.presentedViewController {
                currentViewController = presentedController
            } else {
                break
            }
        }
        return currentViewController
    }
}

extension UITabBarController: TopViewControllerProvider {
    var topViewController: UIViewController? {
        return self.selectedViewController
    }
}

extension UINavigationController: TopViewControllerProvider {}

