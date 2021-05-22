//
//  EnterPasswordViewController.swift
//  WatchTogether
//
//  Created by emin on 22.05.2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol EnterPasswordViewDelegate: AnyObject {
    func enterPasswordViewControllerDidEnterPassword(_ controller: EnterPasswordViewController?, password: String, selectedIndex: Int)
    func enterPasswordViewControllerShouldClose(_ controller: EnterPasswordViewController?)
}

class EnterPasswordViewController: WTViewController {

    @IBOutlet weak var passwordField: MDCOutlinedTextField! {
        didSet {
            passwordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            passwordField.label.text = "Şifre"
        }
    }
    
    weak var delegate: EnterPasswordViewDelegate?
    
    var selectedIndex = 0
    
    override func setup() {
        super.setup()
    }

    @IBAction func joinButtonTapAction(_ sender: Any) {
        guard let password = self.passwordField.text,
              password.count > 0 else { return }
        self.delegate?.enterPasswordViewControllerDidEnterPassword(self, password: password, selectedIndex: self.selectedIndex)
    }
    @IBAction func dismissButtonTapAction(_ sender: Any) {
        self.delegate?.enterPasswordViewControllerShouldClose(self)
    }
}

extension EnterPasswordViewController {
    static func showOverCurrentContent(context: UIViewController, delegate: EnterPasswordViewDelegate, selectedIndex: Int) {
        
        let grayview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        grayview.tag = 664636
        grayview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        context.view.addSubview(grayview)
        
        let vc = SF.makeEnterPasswordVC(index: selectedIndex)
        vc.delegate = delegate
        
        let navHeight = context.navigationController?.navigationBar.frame.height ?? 0
        let screenHeight = context.view.bounds.height
        
        let height: CGFloat = (screenHeight - navHeight) * 0.5
        
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: min(400, height))
        
        vc.view.center.x = context.view.center.x
        
        context.addChild(vc)
        grayview.addSubview(vc.view)
        
        
        DispatchQueue.main.async {
            vc.view.center.y = screenHeight * 1.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                vc.view.center.y = context.view.center.y + (navHeight / 1.5)
                vc.view.layoutIfNeeded()
            }, completion: nil)
        }
       
        vc.didMove(toParent: context)
    }
    
    static func hide(context: UIViewController, passwordVC: EnterPasswordViewController?) {
    
        for vw in context.view.subviews {
            if vw.tag == 664636 {
                UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                    passwordVC?.view.center.y = UIScreen.main.bounds.height + (passwordVC?.view.bounds.height ?? 0)/2
                    passwordVC?.view.layoutIfNeeded()
                }) { (_) in
                    vw.removeFromSuperview()
                }
                
            }
        }
        
        for child in context.children {
            if child.view.tag == 664636 {
                child.removeFromParent()
            }
        }
    }
}
