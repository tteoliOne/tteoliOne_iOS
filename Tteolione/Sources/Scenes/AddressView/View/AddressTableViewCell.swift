//
//  AddressTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import UIKit
import SnapKit

final class AddressTableViewCell: BaseTableViewCell {
    
    let addressTitleLabel = RegularLabel(text: "Title Address",
                                         font: Font.regular16,
                                         color: .myAppBlack)
    let addressSubTitleLabel = RegularLabel(text: "subTitle Address",
                                           font: Font.regular13,
                                           color: .myAppBlack)
    
    let stackView: UIStackView = {
        let stview = UIStackView()
        stview.axis = .vertical
        stview.distribution  = .fill
        stview.alignment = .fill
        stview.spacing = 8
        return stview
    }()
    
    override func configureHierarchy() {
        [stackView].forEach { contentView.addSubview($0) }
        [addressTitleLabel, addressSubTitleLabel].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
