//
//  CommonTextField.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class CommonTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        frame.size.height = 48
        backgroundColor = .clear
        textColor = .black
        tintColor = .black
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
