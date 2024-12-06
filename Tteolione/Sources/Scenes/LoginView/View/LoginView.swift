//
//  LoginView.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    
    //MARK: - 로고
    private let teoliOneNumberLogo: UILabel = {
        let label = UILabel()
        label.text = AppText.Logo.teoliOneNumber
        label.font = Font.Andong60
        label.textColor = .myAppMain
        return label
    }()

    private let teoliOneTextLogo: UILabel = {
        let label = UILabel()
        label.text = AppText.Logo.teoliOneText
        label.font = Font.Andong30
        label.textColor = .myAppMain
        return label
    }()
    
    private lazy var logoStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [teoliOneNumberLogo, teoliOneTextLogo])
        stview.axis = .vertical
        stview.alignment = .center
        return stview
    }()
    
    // MARK: - 아이디 입력
    private let emailTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .myAppLightGray
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    let emailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Login.id
        label.font = Font.Andong18
        label.textColor = .myAppDarkGray
        return label
    }()
    
    let emailTextField = CommonTextField()
    
    // MARK: - 비밀번호 입력하는 텍스트 뷰
    private let passwordTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .myAppLightGray
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    let passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Login.password
        label.font = Font.Andong18
        label.textColor = .myAppDarkGray
        return label
    }()
    
    let passwordTextField = CommonTextField()
    
    // 패스워드에 "표시"버튼
    lazy var passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(AppText.Login.passwordShow, for: .normal)
        button.setTitleColor(.myAppDarkGray, for: .normal)
        button.titleLabel?.font = Font.Andong13
        return button
    }()
    
    // MARK: - 로그인버튼
    lazy var loginButton = CommonButton(title: .login)
    
    // 이메일, 패스워드, 로그인버튼 스택뷰에 배치
    private lazy var loginStackView: UIStackView = {
        let stview = UIStackView()
        stview.spacing = 20
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    //MARK: - 아이디 찾기, 비밀번호 변경, 회원가입
    let idSearchButton = LabelButton(title: .findID)
    private let slash = SlashLabel()
    let signUpButton = LabelButton(title: .signUp)
    private let slash2 = SlashLabel()
    let passwordResetButton = LabelButton(title: .resetPassword)
    
    private lazy var signStackView: UIStackView = {
        let stview = UIStackView()
        stview.spacing = 12
        stview.axis = .horizontal
        stview.alignment = .center
        return stview
    }()
    
    //MARK: - 또는 부분
    private let boundarView = BoundarView(.myAppDarkGray)
    private let orTextLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Login.orText
        label.textColor = .myAppDarkGray
        label.font = Font.Andong16
        return label
    }()
    private let boundarView2 = BoundarView(.myAppDarkGray)
    private let orStackView: UIStackView = {
        let stview = UIStackView()
        stview.spacing = 12
        stview.axis = .horizontal
        stview.alignment = .center
        return stview
    }()
    
    //MARK: - 소셜로그인
    let appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.setTitle(" Sign in with Apple", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = Font.regular17
        button.imageView?.tintColor = .myAppBlack
        button.layer.borderWidth = 0.5
        return button
    }()
    
    override func configureHierarchy() {
        [logoStackView, loginStackView,
         signStackView, orStackView,
         appleLoginButton]
            .forEach { addSubview($0) }
        
        [emailInfoLabel, emailTextField]
            .forEach { emailTextFieldView.addSubview($0) }
        
        [passwordInfoLabel, passwordTextField,
         passwordSecureButton]
            .forEach { passwordTextFieldView.addSubview($0) }
        
        [emailTextFieldView, passwordTextFieldView,
         loginButton]
            .forEach { loginStackView.addArrangedSubview($0) }
        
        [idSearchButton, slash,
         passwordResetButton, slash2,
         signUpButton]
            .forEach { signStackView.addArrangedSubview($0) }
        
        [boundarView, orTextLabel,
         boundarView2]
            .forEach { orStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        logoStackView.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
        }

        emailTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        emailInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextFieldView)
            make.leading.equalTo(emailTextFieldView).inset(8)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(emailTextFieldView).inset(8)
            make.top.equalTo(emailTextFieldView).inset(16)
            make.bottom.equalTo(emailTextFieldView).inset(4)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextFieldView)
            make.leading.equalTo(passwordTextFieldView).inset(8)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(passwordTextFieldView).inset(8)
            make.top.equalTo(passwordTextFieldView).offset(16)
            make.bottom.equalTo(passwordTextFieldView).inset(4)
        }
        
        passwordSecureButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextFieldView).inset(8)
            make.centerY.equalTo(passwordTextFieldView)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(logoStackView.snp.bottom).offset(80)
        }
        
        signStackView.snp.makeConstraints { make in
            make.top.equalTo(loginStackView.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        orStackView.snp.makeConstraints { make in
            make.leading.equalTo(signStackView.snp.leading)
            make.trailing.equalTo(signStackView.snp.trailing)
            make.top.equalTo(signStackView.snp.bottom).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        orTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(orStackView)
        }
        
        boundarView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        boundarView2.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(orStackView.snp.bottom).offset(20)
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearsOnBeginEditing = false
    }
    
}

//MARK: - emailInfoLabel, passwordInfoLabel위치 변경
extension LoginView {
    
    func animateLabelUp(_ label: UILabel?) {
        guard let label = label else { return }
        
        UIView.animate(withDuration: 0.3) {
            label.font = Font.Andong11
            label.transform = CGAffineTransform(translationX: 0, y: -13)
        }
    }
    
    func animateLabelDown(_ label: UILabel?, textField: UITextField?) {
        guard let label = label, let textField = textField else { return }
        
        if textField.text?.isEmpty ?? true {
            UIView.animate(withDuration: 0.3) {
                label.font = Font.Andong18
                label.transform = .identity
            }
        }
    }
    
}
