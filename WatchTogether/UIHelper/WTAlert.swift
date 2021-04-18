//
//  WTAlert.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import PopupDialog
import UIKit

final class WTAlert {
    
    enum ButtonType {
        case cancel(String)
        case `default`(String)
    }
    
    static public func setApperance() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.backgroundColor = .white
        
        dialogAppearance.titleFont = R.font.kanitBold(size: 16)!
        dialogAppearance.titleColor = R.color.mainBlueColorLight()!
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont = R.font.kanitRegular(size: 14)!
        dialogAppearance.messageColor = R.color.mainBlueColorLight()!
        dialogAppearance.messageTextAlignment = .center
        
        let containerAppearance = PopupDialogContainerView.appearance()
        containerAppearance.backgroundColor = .white
        containerAppearance.cornerRadius = 28
        containerAppearance.shadowEnabled = true
        containerAppearance.shadowColor = .black
        containerAppearance.shadowOpacity = 0.12
        containerAppearance.shadowRadius = 36
        containerAppearance.shadowOffset = CGSize(width: 3, height: 3)
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color = R.color.mainBlueColorDark()!
        overlayAppearance.blurRadius = 6
        overlayAppearance.blurEnabled = true
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity = 0.6
        
        let buttonAppearance = DefaultButton.appearance()
        buttonAppearance.titleFont      = R.font.kanitBold(size: 16)!
        buttonAppearance.titleColor     = R.color.mainBlueColorDark()!
        buttonAppearance.buttonColor    = .white
        buttonAppearance.separatorColor = R.color.mainBlueColorLight()!
        
        CancelButton.appearance().titleColor = R.color.mainBlueColorDark()!
        CancelButton.appearance().titleFont = R.font.kanitRegular(size: 16)!
        CancelButton.appearance().separatorColor = R.color.mainBlueColorLight()!
    }
}

extension WTAlert {
    
    @discardableResult
    static public func show(_ context: UIViewController? = nil, title: String?,
                            message: String?,
                            buttons: [PopupDialogButton]? = nil) -> PopupDialog {
                
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn)
        
        var mutableButtons = buttons ?? []
        if mutableButtons.isEmpty {
            let cancelButton = CancelButton(title: "İptal", action: {
            })
            mutableButtons.append(cancelButton)
        }
        
        popup.addButtons(mutableButtons)
        let targetVC = context ?? UIApplication.shared.keyWindow?.rootViewController
        targetVC?.present(popup, animated: true, completion: nil)
        
        return popup
    }
    
}
