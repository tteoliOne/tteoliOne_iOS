//
//  PasswordExplainLabelView.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import UIKit
import SnapKit

final class PasswordExplainLabelView: BaseView {
    
    private let checkImage = CheckImageView()
    private let explainLabel = PasswordExplainLabel()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkImage, explainLabel])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    override func configureHierarchy() { 
        addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configure(text: AppPasswordExplain) {
        explainLabel.configure(text: text)
    }
    
    func updateState(isValid: Bool) {
        checkImage.configure(isValid: isValid)
        explainLabel.textColor = isValid ? .black : .myAppDarkGray
    }
}
