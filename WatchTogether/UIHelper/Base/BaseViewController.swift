//
//  BaseViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation
import SVProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerEvents()
        self.setup()
    }
    
    func setup() {
        
    }

    func registerEvents() {
        
    }

    func refreshViews() {
        
    }
    
    func registerChangableViewModel(viewModel: BaseViewModel?) {
        
        viewModel?.onChange = { [weak self] in
            
            self?.refreshViews()
        }
    }
    
    func registerLoadableViewModel(viewModel: BaseViewModel?) {
        
        
        viewModel?.onLoadDidStart = { status in
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: status)
            }
        }
        
        viewModel?.onLoadDidFinish = {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
        
        viewModel?.onLoadDidFinishWithError = { (error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    WTAlert.show(title: nil, message: error.message)

                }
            }
        }
        
        viewModel?.onChange = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshViews()
            }
        }
    }
    
    func showProgress(status: String? = nil) {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: status)
        }
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}


