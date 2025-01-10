//
//  CommonButton.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class CommonButton: UIButton {
    
    init(title: AppButtonTitle,
         corner: CGFloat,
         backgroundColor: UIColor,
         textColor: UIColor,
         font: UIFont? = Font.Andong18) {
        super.init(frame: .zero)
        layer.cornerRadius = corner
        self.backgroundColor = backgroundColor
        setTitle(title.rawValue, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
