//
//  PostButton.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit

class PostButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostButton {
    private func configureButton() {
        var configure = UIButton.Configuration.filled()
        configure.baseBackgroundColor = .myAppMain
        configure.cornerStyle = .capsule
        configure.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        self.setTitle("상품등록", for: .normal)
        self.configuration = configure
        self.layer.shadowRadius = 25
        self.layer.shadowOpacity = 0.3
    }
}
