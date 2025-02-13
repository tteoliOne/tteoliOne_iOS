//
//  NameView.swift
//  Tteolione
//
//  Created by 전준영 on 12/28/24.
//

import UIKit
import SnapKit

final class NameView: BaseView {
    
    let topBarView = TopBarView()
    private let iconWithLabelView = IconWithLabelView()
    private let boundarView = BoundarView(.myAppBlack)
    let nameInputTextField = LineTextField(text: .username,
                                            keboard: .default,
                                            isSecure: nil)
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.joinUserNameExplain
        label.font = Font.bold15
        label.textColor = .myAppBlack
        return label
    }()
    let checkButton = JoinButton(title: .next)
    
    override func configureHierarchy() {
        [topBarView, iconWithLabelView,
         boundarView, checkButton,
         nameInputTextField, explanationLabel].forEach { addSubview($0) }
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
        
        nameInputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(iconWithLabelView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        boundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameInputTextField).offset(-8)
            make.top.equalTo(nameInputTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(boundarView).inset(4)
        }
        
        checkButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    override func configureView() {
        iconWithLabelView.configure(icon: .userName,
                                    text: AppText.Join.joinUserName)
    }
    
}

extension NameView {
    
    func setButton(_ isEnabled: Bool) {
        checkButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
        checkButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
        checkButton.isEnabled = isEnabled
    }
    
}
