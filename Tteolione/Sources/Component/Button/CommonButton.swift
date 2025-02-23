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
         symbolTintColor: UIColor? = nil,
         isSymbolLeading: Bool = true) {
        super.init(frame: .zero)
        
        layer.cornerRadius = corner
        self.backgroundColor = backgroundColor
        setTitle(title.rawValue, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        
        if let symbol = symbol {
            setImage(symbol, for: .normal)
            imageView?.tintColor = symbolTintColor
            configureImagePosition(isSymbolLeading: isSymbolLeading)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImagePosition(isSymbolLeading: Bool) {
        contentHorizontalAlignment = .center
        let spacing: CGFloat = 12
        semanticContentAttribute = isSymbolLeading ? .forceLeftToRight : .forceRightToLeft
        
        if isSymbolLeading {
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
        } else {
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: spacing / 2,
                bottom: 0,
                right: -spacing / 2
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -spacing / 2,
                bottom: 0,
                right: spacing / 2
            )
        }
    }
    
}
