//
//  SymbolImageButton.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit

class SymbolImageButton: UIButton {
    
    init(name: String) {
        super.init(frame: .zero)
        backgroundColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        setImage(UIImage(systemName: name, withConfiguration: imageConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
