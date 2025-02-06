//
//  DeclaractionTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit
import SnapKit
import RxSwift

final class DeclaractionTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    private let listTitleLabel = RegularLabel(text: "리스트",
                                              font: Font.regular28,
                                              color: .myAppBlack)
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.right")?
            .withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .myAppBlack
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
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
            make.size.equalTo(16)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .myAppLightGray2
    }
    
}

extension DeclaractionTableViewCell {
    func configure(with item: MenuItem) {
        listTitleLabel.text = item.title
    }
}
