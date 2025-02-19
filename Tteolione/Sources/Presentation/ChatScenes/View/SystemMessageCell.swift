//
//  SystemMessageCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import UIKit
import SnapKit

final class SystemMessageCell: BaseTableViewCell {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(messageLabel)
    }
    
    override func configureLayout() {
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
}
