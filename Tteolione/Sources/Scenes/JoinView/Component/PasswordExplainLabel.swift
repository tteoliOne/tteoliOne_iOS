//
//  PasswordExplainLabel.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import UIKit

class PasswordExplainLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        font = Font.bold18
        textColor = .myAppDarkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: AppPasswordExplain) {
        self.text = text.rawValue
    }
}
