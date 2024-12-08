//
//  AuthNumView.swift
//  Tteolione
//
//  Created by 전준영 on 12/7/24.
//

import UIKit
import SnapKit

final class AuthNumView: BaseView {
    
    let topBarView = TopBarView()
    private let iconWithLabelView = IconWithLabelView()
    private let boundarView = BoundarView(.myAppBlack)
    let authNumInputTextField = JoinTextField(text: .authNum,
                                            keboard: .default,
                                            isSecure: nil)
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.joinAuthTime
        label.font = Font.bold15
        label.textColor = .myAppRed
        return label
    }()
    let joinButton = JoinButton(title: .authNum)
    
    override func configureHierarchy() {
        [topBarView, iconWithLabelView,
         boundarView, joinButton,
         authNumInputTextField, explanationLabel].forEach { addSubview($0) }
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
        
        authNumInputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.top.equalTo(iconWithLabelView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        boundarView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(authNumInputTextField).offset(-8)
            make.top.equalTo(authNumInputTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(boundarView).inset(4)
        }
        
        joinButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    override func configureView() {
        iconWithLabelView.configure(icon: .authNum,
                                    text: AppText.Join.joinAuthNum)
    }
    
}

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        AuthNumViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider{
    static var previews: some View{
        ViewControllerPresentable()
    }
}

#endif
