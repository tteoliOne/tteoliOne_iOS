//
//  LikeButton.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit

class LikeButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        setImage(UIImage(systemName: "heart", withConfiguration: imageConfig)?
            .withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
