//
//  IconWithLabelView.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit
import SnapKit

final class IconWithLabelView: UIView {
    
    private let iconImageView = JoinImageView(image: .email)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold20
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(icon: AppJoinImage, text: String) {
        iconImageView.configure(image: icon)
        titleLabel.text = text
    }
}
