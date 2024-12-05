//
//  LabelButton.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import Foundation

import UIKit

class LabelButton: UIButton {
    
    init(title: AppButtonTitle) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        setTitleColor(.myAppBlack, for: .normal)
        setTitle(title.rawValue, for: .normal)
        titleLabel?.font = Font.Andong15
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
