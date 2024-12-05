//
//  CommonButton.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class CommonButton: UIButton {
    
    init(title: AppButtonTitle) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 8
        backgroundColor = .myAppDarkGray
        setTitle(title.rawValue, for: .normal)
        titleLabel?.font = Font.Andong18
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
