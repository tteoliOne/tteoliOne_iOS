//
//  LoadImageView.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import UIKit

class LoadImageView: UIImageView {
    
    private var currentImageURL: URL?
    
    init() {
        super.init(frame: .zero)
        self.image = UIImage(systemName: "31photo")?
            .withTintColor(.myAppLightGray2, renderingMode: .alwaysOriginal)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from url: URL) {
        currentImageURL = url
        Task {
            let image = await ImageCacheManager.shared.loadImage(from: url)
            if currentImageURL == url {
                self.image = image
            }
        }
    }
    
}
