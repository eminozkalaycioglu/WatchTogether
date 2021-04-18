//
//  BaseViewModel.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation
import UIKit

typealias Event = (()->())
typealias ErrorEvent = ((Error)->())

class BaseViewModel: NSObject {

    enum LoadState {
        case notLoaded
        case initialLoad
        case other
    }
    
    var onChange: Event?
    
    var isLoading = false
    var loadState = LoadState.notLoaded
    var center = NotificationCenter.default
    
    var onLoadDidStart: ((_ status: String?)->Void)?
    var onLoadDidFinish: Event?
    var onLoadDidFinishWithError: ((PresentableError)->())?

    var isInitialLoadFinished: Bool = false
    
    weak var viewController: UIViewController?
    
    func change() {
        DispatchQueue.main.async {
            self.onChange?()
        }
    }
    
    func loadDidStart(withStatus: String? = nil) {
        DispatchQueue.main.async {
            self.isLoading = true
            self.onLoadDidStart?(withStatus)
        }
    }
    
    func loadDidFinish() {
        DispatchQueue.main.async {
            self.isInitialLoadFinished = true
            self.isLoading = false
            self.updateLoadState()
            self.onLoadDidFinish?()
        }
    }
    
    func loadDidFinishWithError(error: PresentableError) {
        DispatchQueue.main.async {
            self.isInitialLoadFinished = true
            self.isLoading = false
            self.updateLoadState()
            self.onLoadDidFinishWithError?(error)
        }
    }
    
    func updateLoadState() {
        if self.loadState == .notLoaded {
            self.loadState = .initialLoad
        } else if self.loadState == .initialLoad {
            self.loadState = .other
        }
    }
    
    func registerNotification(name: NSNotification.Name, selector: Selector) {
        center.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func postNotification(name: NSNotification.Name, userInfo: [AnyHashable : Any]? = nil) {
        center.post(name: name, object: nil, userInfo: userInfo)
    }
}
