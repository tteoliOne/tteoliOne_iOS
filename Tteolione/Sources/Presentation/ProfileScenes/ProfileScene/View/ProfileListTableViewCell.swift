//
//  ProfileListTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import SnapKit

final class ProfileListTableViewCell: BaseTableViewCell {
    
    private let listTitleLabel = AndongLabel(text: "리스트",
                                             font: Font.Andong25,
                                             color: .white)
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.right")?
            .withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        return imageView
    }()

    override func configureHierarchy() {
        [listTitleLabel, chevronImageView].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        listTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(25)
        }
    }
}
