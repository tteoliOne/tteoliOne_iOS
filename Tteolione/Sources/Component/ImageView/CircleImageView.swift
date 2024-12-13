//
//  CircleImageView.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit

class CircleImageView: UIImageView {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
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
    
    func configure(setImage: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let key = NSString(string: "\(setImage.hashValue)")
            if let cachedImage = CircleImageView.imageCache.object(forKey: key) {
                DispatchQueue.main.async {
                    self?.image = cachedImage
                }
            } else {
                CircleImageView.imageCache.setObject(setImage, forKey: key)
                DispatchQueue.main.async {
                    self?.image = setImage
                }
            }
        }
    }
    
}
