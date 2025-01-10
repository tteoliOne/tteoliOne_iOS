//
//  AndongLabel.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit

class AndongLabel: UILabel {
    
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        font = Font.Andong18
        textColor = color
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
