//
//  SignUpFinshView.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import UIKit
import SnapKit

final class SignUpFinshView: BaseView {
    
    private let tteoliOneTextLogo: UILabel = {
        let label = UILabel()
        label.text = AppText.Logo.tteoliOneText
        label.font = Font.Andong100
        label.textColor = .myAppMain
        return label
    }()
    
    private let mentionLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.joinFinsh
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Font.bold25
        return label
    }()
    
    let joinButton = JoinButton(title: .finshSignUp)
    
    override func configureHierarchy() {
        [tteoliOneTextLogo, mentionLabel,
         joinButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tteoliOneTextLogo.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY).offset(-100)
        }
        
        mentionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.centerY)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        joinButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    override func configureView() {
        joinButton.backgroundColor = .myAppMain
        joinButton.setTitleColor(.white, for: .normal)
    }
    
}
