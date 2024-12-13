//
//  CircleImageView.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit

class CircleImageView: UIImageView {
    
    init(joinImage: AppJoinImage,
         corner: CGFloat,
         border: CGFloat) {
        super.init(frame: .zero)
        image = UIImage(named: joinImage.rawValue)
        layer.cornerRadius = corner
        layer.borderWidth = border
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
