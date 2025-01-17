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
         font: UIFont? = Font.Andong18,
         symbol: UIImage? = nil,
         symbolTintColor: UIColor? = nil) {
        super.init(frame: .zero)
        
        layer.cornerRadius = corner
        self.backgroundColor = backgroundColor
        setTitle(title.rawValue, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        
        if let symbol = symbol {
            setImage(symbol, for: .normal)
            imageView?.tintColor = symbolTintColor
            configureImagePosition()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImagePosition() {
        contentHorizontalAlignment = .center
        let spacing: CGFloat = 12
        semanticContentAttribute = .forceLeftToRight
        imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -spacing / 2,
            bottom: 0,
            right: spacing / 2
        )
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: spacing / 2,
            bottom: 0,
            right: -spacing / 2
        )
    }
    
}

