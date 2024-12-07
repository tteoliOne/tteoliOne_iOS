//
//  JoinImageView.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit

class JoinImageView: UIImageView {
    
    init(image: AppJoinImage) {
        super.init(frame: .zero)
        configure(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: AppJoinImage) {
        self.image = UIImage(systemName: image.rawValue)?
            .withTintColor(.myAppBlack, renderingMode: .alwaysOriginal)
    }
}
