//
//  BoldLabel.swift
//  Tteolione
//
//  Created by 전준영 on 1/23/25.
//

import UIKit

class BoldLabel: UILabel {
    
    init(text: String, font: UIFont? = Font.bold16, color: UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = font
        textColor = color
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
