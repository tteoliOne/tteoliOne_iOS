//
//  ReportView.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit
import SnapKit

final class ReportView: BaseView {
    
    private let OkLabel = BoldLabel(text: "OK",
                                    font: Font.bold50,
                                    color: .myAppBlack)
    private let middleTitleLabel: RegularLabel = {
        let label = RegularLabel(text: "신고가 접수 되었습니다.",
                                 font: Font.regular28,
                                 color: .myAppBlack)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    private let detailLabel: RegularLabel = {
        let label = RegularLabel(text: "여러분의 의견 감사합니다.\n최선의 다해 노력하겠습니다.",
                                 font: Font.regular25,
                                 color: .myAppBlack)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    let checkButton = CommonButton(title: .check,
                                   corner: 16,
                                   backgroundColor: .white,
                                   textColor: .myAppBlack,
                                   font: Font.regular20)
    
    override func configureHierarchy() {
        [OkLabel, middleTitleLabel,
         detailLabel, checkButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        OkLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        middleTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(OkLabel.snp.bottom).offset(12)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(Device.screenWidth)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        checkButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.height.equalTo(44)
        }
    }
}
