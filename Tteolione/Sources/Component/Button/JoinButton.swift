//
//  JoinButton.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit

class JoinButton: UIButton {
    
    init(title: AppButtonTitle) {
        super.init(frame: .zero)
        
        backgroundColor = .myAppLightGray2
        layer.cornerRadius = 5
        setTitle(title.rawValue, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = Font.Andong16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
