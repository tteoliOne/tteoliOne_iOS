//
//  UpAndDownButton.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import UIKit

class UpAndDownButton: UIButton {
    
    init(size: CGFloat? = 22, title: String) {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size ?? 22, weight: .light)
        setImage(UIImage(systemName: title, withConfiguration: imageConfig)?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
