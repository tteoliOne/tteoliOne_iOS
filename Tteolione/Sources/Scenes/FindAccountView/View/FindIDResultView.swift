//
//  FindIDResultView.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import UIKit
import SnapKit

final class FindIDResultView: BaseView {
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Account.findResult
        label.font = Font.bold30
        label.textColor = .myAppBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let boundarView = BoundarView(.myAppBlack)
    private let iDLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Account.findResultID
        label.font = Font.bold20
        label.textColor = .myAppBlack
        return label
    }()
    let resultIDLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold20
        label.textColor = .myAppBlack
        return label
    }()
    let changePasswordButton = JoinButton(title: .resetPassword)
    let loginButton = JoinButton(title: .finshSignUp)
    
    override func configureHierarchy() {
        [explanationLabel, boundarView,
         iDLabel, resultIDLabel,
         changePasswordButton, loginButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        explanationLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        boundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerY.equalTo(explanationLabel.snp.bottom).offset(120)
            make.height.equalTo(1)
        }
        
        iDLabel.snp.makeConstraints { make in
            make.bottom.equalTo(boundarView.snp.top).offset(-4)
            make.width.equalTo(40)
            make.leading.equalTo(boundarView).offset(40)
        }
        
        resultIDLabel.snp.makeConstraints { make in
            make.leading.equalTo(iDLabel.snp.trailing).offset(8)
            make.trailing.equalTo(boundarView.snp.trailing).inset(40)
            make.bottom.equalTo(boundarView.snp.top).offset(-4)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.centerX).offset(-12)
            make.height.equalTo(72)
        }
        
        loginButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.centerX).offset(12)
            make.height.equalTo(72)
        }
    }
    
    override func configureView() {
        loginButton.backgroundColor = .myAppMain
        loginButton.setTitleColor(.white, for: .normal)
    }
    
}
