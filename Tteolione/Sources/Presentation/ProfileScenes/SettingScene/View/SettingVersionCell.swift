//
//  SettingVersionCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import SnapKit

final class SettingVersionCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let versionLabel = UILabel()
    
    override func configureHierarchy() {
        [titleLabel, versionLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String, version: String) {
        titleLabel.text = title
        versionLabel.text = version
    }
}
