//
//  SlashLabel.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class SlashLabel: UILabel {
    
    init(font: UIFont) {
        super.init(frame: .zero)
        
        text = AppText.Login.slash
        self.font = font
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
