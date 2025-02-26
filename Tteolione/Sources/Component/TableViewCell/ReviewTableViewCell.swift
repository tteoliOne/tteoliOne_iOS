//
//  ReviewTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import UIKit
import SnapKit
import RxSwift

final class ReviewTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let shadowView = ShadowView()
    private let nicknameLabel = BoldLabel(text: "닉네임",
                                          font: Font.bold18,
                                          color: .myAppBlack)
    private let contentLabel = RegularLabel(text: "내용",
                                            font: Font.regular15,
                                            color: .myAppDarkGray)
    private let thumbCountView = ShadowView(color: .white,
                                            corner: 18,
                                            shadowColor: UIColor(red: 0x58/255.0,
                                                                 green: 0x8F/255.0,
                                                                 blue: 0x11/255.0,
                                                                 alpha: 1.0).cgColor)
    private let thumbCountLabel = AndongLabel(text: "0",
                                              font: Font.Andong15,
                                              color: .myAppBlack)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
        [shadowView].forEach { contentView.addSubview($0) }
        [nicknameLabel, contentLabel, thumbCountView].forEach { shadowView.addSubview($0) }
        [thumbCountLabel].forEach { thumbCountView.addSubview($0) }
    }
    
    override func configureLayout() {
        shadowView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(50)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(shadowView)
            make.leading.equalTo(shadowView).inset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(shadowView).inset(8)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(12)
            make.trailing.equalTo(shadowView).inset(56)
            make.bottom.equalTo(shadowView).inset(8)
        }
        
        thumbCountView.snp.makeConstraints { make in
            make.centerY.equalTo(shadowView)
            make.trailing.equalTo(shadowView).inset(12)
            make.size.equalTo(36)
        }
        
        thumbCountLabel.snp.makeConstraints { make in
            make.center.equalTo(thumbCountView)
        }
    }
    
    override func configureView() {
        contentLabel.numberOfLines = 0
    }
}

extension ReviewTableViewCell {
    
    func setUI(_ data: MyReviewDTO) {
        nicknameLabel.text = data.writer
        contentLabel.text = data.content
        thumbCountLabel.text = "\(data.ddabongScore)"
    }
    
}
