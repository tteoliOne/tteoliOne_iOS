//
//  JoinTextField.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit

class JoinTextField: UITextField {
    
    init(text: AppTextFieldPlaceholder,
         keboard: UIKeyboardType?,
         isSecure: Bool?) {
        super.init(frame: .zero)
        frame.size.height = 48
        backgroundColor = .clear
        textColor = .myAppBlack
        tintColor = .myAppBlack
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        placeholder = text.rawValue
        keyboardType = keboard ?? .default
        isSecureTextEntry = isSecure ?? false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
