//
//  WTTextField.swift
//  WatchTogether
//
//  Created by emin on 20.04.2021.
//

import Foundation
import MaterialComponents.MaterialTextControls_OutlinedTextFields

extension MDCOutlinedTextField {
    
    enum InputType {
        case password
        case `default`
    }
    
    func wtTheme(icon: UIImage?, inputType: InputType = .default) {
        
        self.font = R.font.kanitMedium(size: 14)
        
        self.setOutlineColor(R.color.textFieldBorderColor()!, for: .normal)
        self.setOutlineColor(R.color.textFieldBorderColor()!, for: .disabled)
        self.setOutlineColor(R.color.buttonBlueColor()!, for: .editing)

        self.setTextColor(R.color.textFieldTextColor()!, for: .normal)
        self.setTextColor(R.color.textFieldTextColor()!, for: .editing)
        self.setTextColor(R.color.textFieldTextColor()!, for: .disabled)

        self.setNormalLabelColor(R.color.textFieldTextColor()!, for: .normal)
        self.setNormalLabelColor(R.color.textFieldTextColor()!, for: .disabled)
        self.setNormalLabelColor(R.color.textFieldTextColor()!, for: .editing)

        self.setFloatingLabelColor(R.color.textFieldTextColor()!, for: .disabled)
        self.setFloatingLabelColor(R.color.textFieldTextColor()!, for: .editing)
        self.setFloatingLabelColor(R.color.textFieldTextColor()!, for: .normal)


        if let icon = icon {
            self.leadingViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
            imageView.contentMode = .right
            imageView.image = icon

            self.leadingView = imageView
        }
        
        if inputType == .password {
            self.isSecureTextEntry = true
            let showHideButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
            showHideButton.contentMode = .left
            showHideButton.addTarget(self, action: #selector(self.showHideAction), for: .touchUpInside)
            showHideButton.setImage(R.image.showIcon()!, for: .normal)
            self.trailingView = showHideButton
            self.trailingViewMode = .always
            
        }
        
        self.sizeToFit()
        
    }
    
    @IBAction private func showHideAction() {
        
        guard let text = self.text,
              text.count > 0 else { return }
        
        self.isSecureTextEntry = !self.isSecureTextEntry
        
        (self.trailingView as? UIButton)?.setImage(self.isSecureTextEntry ? R.image.showIcon()! : R.image.hideIcon()!, for: .normal)
        
    }
}
