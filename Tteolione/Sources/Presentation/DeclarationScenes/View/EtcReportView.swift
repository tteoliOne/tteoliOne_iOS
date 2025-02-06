//
//  EtcReportView.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit
import SnapKit

final class EtcReportView: BaseView {
    
    private let titleLabel = BoldLabel(text: "기타 신고",
                                       font: Font.bold30,
                                       color: .myAppBlack)
    private let reportView = ShadowView()
    lazy var reportTextView: UITextView = {
        let view = UITextView()
        view.font = Font.regular15
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.myAppDarkGray.cgColor
        view.tintColor = .black
        view.textAlignment = .left
        view.isScrollEnabled = true
        view.textColor = .lightGray
        return view
    }()
    var remainCountLabel = RegularLabel(text: AppText.PostProduct.detailWordCount,
                                        color: .myAppLightGray2)
    let reportButton = CommonButton(title: .report,
                                    corner: 16,
                                    backgroundColor: .myAppRed,
                                    textColor: .white,
                                    font: Font.regular20)
    
    override func configureHierarchy() {
        [titleLabel, reportButton,
         reportView, reportTextView,
         remainCountLabel].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        reportButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        reportView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(reportButton.snp.top).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
        }
        
        reportTextView.snp.makeConstraints { make in
            make.edges.equalTo(reportView).inset(20)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(reportView).inset(8)
        }
    }
}
