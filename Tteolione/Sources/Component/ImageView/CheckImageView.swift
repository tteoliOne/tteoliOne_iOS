//
//  CheckImageView.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import UIKit

class CheckImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.image = UIImage(systemName: "checkmark")?
            .withTintColor(.myAppDarkGray, renderingMode: .alwaysOriginal)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isValid: Bool) {
        self.image = UIImage(systemName: "checkmark")?
            .withTintColor(isValid ? .myAppMain : .myAppDarkGray,
                           renderingMode: .alwaysOriginal)
    }
}
