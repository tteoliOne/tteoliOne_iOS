//
//  SettingTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    
    override func configureHierarchy() {
        [titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
