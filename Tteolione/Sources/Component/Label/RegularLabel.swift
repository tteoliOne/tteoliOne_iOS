//
//  RegularLabel.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit

class RegularLabel: UILabel {
    
    init(text: String, font: UIFont? = Font.regular16, color: UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = font
        textColor = color
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
