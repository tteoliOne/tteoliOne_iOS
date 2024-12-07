//
//  BackButton.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit

class BackButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        setImage(UIImage(systemName: "chevron.backward", withConfiguration: imageConfig)?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
