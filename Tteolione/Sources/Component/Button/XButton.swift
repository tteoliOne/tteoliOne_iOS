//
//  XButton.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit

class XButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        setImage(UIImage(systemName: "multiply", withConfiguration: imageConfig)?
            .withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
