//
//  AppRouter.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

extension WTViewController {
    var router: AppRouter { AppRouter.shared }
}

final class AppRouter {
    
    static let shared = AppRouter()
    
    private let topViewControllerProvider = DefaultTopViewControllerProvider()
    
    var window: UIWindow?
    
    var visibleViewController: UIViewController? {
        topViewControllerProvider.topViewController
    }
    
    public static func configureWithWindow(_ window: UIWindow?, initalViewController: UIViewController) {
        shared.window = window
        shared.window?.rootViewController = initalViewController
        shared.window?.makeKeyAndVisible()
    }
    
    func setRootViewController( _ viewController: UIViewController ) {
        
        guard let window = self.window else {
            fatalError("Window is not configured!")
        }
        
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.33, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }, completion: nil)
    }
    
    /// En üst sahneden present yapar.
    func present(_ viewController: UIViewController, from: UIViewController? = nil) {
        let presentingVC = from ?? topViewControllerProvider.topViewController
        presentingVC?.present(viewController, animated: true)
    }
    
    /// En üst sahneden push yapar.
    func push(_ viewController: UIViewController, from: UIViewController? = nil) {
        let source = from ?? topViewControllerProvider.topViewController
        guard let navigationController = source?.navigationController else {
            assertionFailure("Attempting to push to navigation controller without having it")
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pop(_ viewController: UIViewController?) {
        let source = viewController ?? topViewControllerProvider.topViewController
        guard let navigationController = source?.navigationController else {
            assertionFailure("Attempting to push to navigation controller without having it")
            return
        }
        navigationController.popViewController(animated: true)
    }
    
}

