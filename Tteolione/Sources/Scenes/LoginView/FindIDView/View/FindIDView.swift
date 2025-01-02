//
//  FindIDView.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import UIKit
import SnapKit

final class FindIDView: BaseView {
    
    let topBarView = TopBarView()
    private let userNameIconWithLabelView = IconWithLabelView()
    private let userNameBoundarView = BoundarView(.myAppBlack)
    let userNameInputTextField = JoinTextField(text: .username,
                                            keboard: .default,
                                            isSecure: nil)
    private let emailIconWithLabelView = IconWithLabelView()
    private let emailBoundarView = BoundarView(.myAppBlack)
    let emailInputTextField = JoinTextField(text: .email,
                                            keboard: .emailAddress,
                                            isSecure: nil)
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Account.findIDExplain
        label.font = Font.bold15
        label.textColor = .myAppBlack
        label.numberOfLines = 0
        return label
    }()
    let checkButton = JoinButton(title: .email)
    
    override func configureHierarchy() {
        [topBarView, userNameIconWithLabelView,
         userNameInputTextField, userNameBoundarView,
         emailIconWithLabelView, emailInputTextField,
         emailBoundarView, explanationLabel,
         checkButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
        
        userNameIconWithLabelView.snp.makeConstraints { make in
            make.leading.equalTo(topBarView.snp.leading).offset(12)
            make.top.equalTo(topBarView.snp.bottom).offset(60)
        }
        
        userNameInputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(userNameIconWithLabelView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        userNameBoundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(userNameInputTextField).offset(-8)
            make.top.equalTo(userNameInputTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        emailIconWithLabelView.snp.makeConstraints { make in
            make.leading.equalTo(topBarView.snp.leading).offset(12)
            make.top.equalTo(userNameBoundarView.snp.bottom).offset(40)
        }
        
        emailInputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(emailIconWithLabelView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        emailBoundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(emailInputTextField).offset(-8)
            make.top.equalTo(emailInputTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(emailBoundarView).inset(4)
        }
        
        checkButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    override func configureView() {
        topBarView.joinLabel.text = AppText.Account.findId
        userNameIconWithLabelView.configure(icon: .userName,
                                    text: AppText.Join.joinUserName)
        emailIconWithLabelView.configure(icon: .email,
                                    text: AppText.Join.joinEmail)
    }
    
}
