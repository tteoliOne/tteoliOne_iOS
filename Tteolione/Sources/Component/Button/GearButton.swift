//
//  GearButton.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit

class GearButton: UIButton {
    
    init(size: CGFloat? = 22) {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size ?? 22, weight: .light)
        setImage(UIImage(systemName: "gearshape.fill", withConfiguration: imageConfig)?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
