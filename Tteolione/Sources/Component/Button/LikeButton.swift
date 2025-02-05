//
//  LikeButton.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit

class LikeButton: UIButton {
    
    private var buttonColor: UIColor
    
    init(color: UIColor) {
        self.buttonColor = color
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .light)
        let defaultImage = UIImage(systemName: "heart", withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysTemplate)
        
        setImage(defaultImage, for: .normal)
        tintColor = buttonColor
        imageView?.contentMode = .scaleAspectFit
    }
    
    func updateLikeState(isLiked: Bool) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .light)
        let imageName = isLiked ? "heart.fill" : "heart"
        
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysTemplate)
        
        setImage(image, for: .normal)
        tintColor = buttonColor
    }
}
