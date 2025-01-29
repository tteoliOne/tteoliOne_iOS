//
//  RecentSearchTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit
import SnapKit
import RxSwift

final class RecentSearchTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    private let recentLabel = RegularLabel(text: "최근검색어",
                                           color: .myAppBlack)
    let deleteButton = XButton(color: .myAppBlack)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [recentLabel, deleteButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        recentLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configure(with text: String) {
        recentLabel.text = text
    }
    
}
