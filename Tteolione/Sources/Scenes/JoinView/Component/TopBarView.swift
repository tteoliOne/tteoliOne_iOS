//
//  TopBarView.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit
import SnapKit

final class TopBarView: BaseView {
    
    private let joinLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.join
        label.font = Font.bold25
        return label
    }()
    
    let backButton = BackButton()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, joinLabel])
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    override func configureHierarchy() {
        addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.leading.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
