//
//  NextButtonCollectionViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import SnapKit

final class NextButtonCollectionViewCell: BaseCollectionViewCell {
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.myAppBlack.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .myAppBlack
        return button
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(button)
    }
    
    override func configureLayout() {
        button.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
    }
    
    func configureButton() {
        
    }
    
}
