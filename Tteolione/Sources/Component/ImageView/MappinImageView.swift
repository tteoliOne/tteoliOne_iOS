//
//  MappinImageView.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit

class MappinImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.image = UIImage(systemName: "mappin")?
            .withTintColor(.myAppLightGray2, renderingMode: .alwaysOriginal)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
