//
//  WithdrawView.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import UIKit
import SnapKit

final class WithdrawView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.MyProduct.withdraw
        label.font = Font.bold20
        label.textColor = .myAppMain
        return label
    }()
    let backButton = BackButton(size: 24)
    private let withdrawLabel = RegularLabel(text: AppText.Etc.withdraw,
                                     font: Font.regular25,
                                     color: .myAppBlack)
    let withdrawButton = CommonButton(title: .withdraw,
                                      corner: 24,
                                      backgroundColor: .myAppMain,
                                      textColor: .white,
                                      font: Font.bold20)
    
    override func configureHierarchy() {
        [backButton, titleLabel,
         withdrawLabel, withdrawButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
        }
        
        withdrawLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    override func configureView() {
        withdrawLabel.textAlignment = .left
        withdrawLabel.numberOfLines = 0
    }
}
