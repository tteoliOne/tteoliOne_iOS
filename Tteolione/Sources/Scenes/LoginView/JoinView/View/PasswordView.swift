//
//  PasswordView.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import UIKit
import SnapKit

final class PasswordView: BaseView {
    
    let topBarView = TopBarView()
    private let iconWithLabelView = IconWithLabelView()
    private let boundarView = BoundarView(.myAppBlack)
    let passwordInputTextField = JoinTextField(text: .password,
                                         keboard: .default,
                                         isSecure: true)
    let passwordExplainViews: [PasswordExplainLabelView] = [
        PasswordExplainLabelView(),
        PasswordExplainLabelView(),
        PasswordExplainLabelView(),
        PasswordExplainLabelView(),
        PasswordExplainLabelView()
    ]
    private lazy var explanationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.alignment = .fill
        return stackView
    }()
    let joinButton = JoinButton(title: .next)
    
    override func configureHierarchy() {
        [topBarView, iconWithLabelView,
         boundarView, joinButton,
         passwordInputTextField, explanationStackView].forEach { addSubview($0) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
        
        iconWithLabelView.snp.makeConstraints { make in
            make.leading.equalTo(topBarView.snp.leading).offset(12)
            make.top.equalTo(topBarView.snp.bottom).offset(60)
        }
        
        passwordInputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(iconWithLabelView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        boundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(passwordInputTextField).offset(-8)
            make.top.equalTo(passwordInputTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        explanationStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(boundarView.snp.bottom).offset(16)
        }
        
        joinButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    override func configureView() {
        iconWithLabelView.configure(icon: .password,
                                    text: AppText.Join.joinPassword)
        let explanations: [AppPasswordExplain] = [
            .num, .specialCharacter,
            .lowercase, .count,
            .space
        ]
        
        for i in stride(from: 0, to: explanations.count, by: 2) {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            
            let firstView = passwordExplainViews[i]
            firstView.configure(text: explanations[i])
            horizontalStackView.addArrangedSubview(firstView)
            
            if i + 1 < explanations.count {
                let secondView = passwordExplainViews[i + 1]
                secondView.configure(text: explanations[i + 1])
                horizontalStackView.addArrangedSubview(secondView)
            }
            
            explanationStackView.addArrangedSubview(horizontalStackView)
        }
    }
    
}
