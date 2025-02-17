//
//  ProfileResetPasswordView.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import UIKit
import SnapKit

final class ProfileResetPasswordView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.MyProduct.resetPassword
        label.font = Font.bold20
        label.textColor = .myAppMain
        return label
    }()
    
    let backButton = BackButton(size: 24)
    
    private let originePasswordTextFieldView = createInputFieldView()
    let originePasswordInfoLabel = createInputInfoLabel(text: AppText.ResetPassword.originalPassword)
    let originePasswordTextField = CommonTextField()
    lazy var originePasswordSecureButton = createSecureButton()
    
    private let newPasswordTextFieldView = createInputFieldView()
    let newPasswordInfoLabel = createInputInfoLabel(text: AppText.ResetPassword.newPassword)
    let newPasswordTextField = CommonTextField()
    lazy var newPasswordSecureButton = createSecureButton()
    
    private let checkNewPasswordTextFieldView = createInputFieldView()
    let checkNewPasswordInfoLabel = createInputInfoLabel(text: AppText.ResetPassword.checkPassword)
    let checkNewPasswordTextField = CommonTextField()
    lazy var checkNewPasswordSecureButton = createSecureButton()
    
    private lazy var loginStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [
            originePasswordTextFieldView,
            newPasswordTextFieldView,
            checkNewPasswordTextFieldView
        ])
        stview.spacing = 20
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    let resetPasswordButton = CommonButton(title: .change,
                                           corner: 12,
                                           backgroundColor: .myAppLightGray2,
                                           textColor: .white)
    
    override func configureHierarchy() {
        [backButton, titleLabel,
         loginStackView, resetPasswordButton]
            .forEach { addSubview($0) }
        [originePasswordInfoLabel,
         originePasswordTextField,
         originePasswordSecureButton]
            .forEach { originePasswordTextFieldView.addSubview($0) }
        
        [newPasswordInfoLabel,
         newPasswordTextField,
         newPasswordSecureButton]
            .forEach { newPasswordTextFieldView.addSubview($0) }
        
        [checkNewPasswordInfoLabel,
         checkNewPasswordTextField,
         checkNewPasswordSecureButton]
            .forEach { checkNewPasswordTextFieldView.addSubview($0) }
    }
    
    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        [originePasswordTextFieldView,
         newPasswordTextFieldView,
         checkNewPasswordTextFieldView].forEach { textFieldView in
            textFieldView.snp.makeConstraints { make in
                make.height.equalTo(48)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            }
        }
        
        originePasswordInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(originePasswordTextFieldView)
            make.leading.equalTo(originePasswordTextFieldView).inset(8)
        }
        
        newPasswordInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(newPasswordTextFieldView)
            make.leading.equalTo(newPasswordTextFieldView).inset(8)
        }
        
        checkNewPasswordInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkNewPasswordTextFieldView)
            make.leading.equalTo(checkNewPasswordTextFieldView).inset(8)
        }
        
        originePasswordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(originePasswordTextFieldView).inset(8)
            make.top.equalTo(originePasswordTextFieldView).offset(16)
            make.bottom.equalTo(originePasswordTextFieldView).inset(4)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(newPasswordTextFieldView).inset(8)
            make.top.equalTo(newPasswordTextFieldView).offset(16)
            make.bottom.equalTo(newPasswordTextFieldView).inset(4)
        }
        
        checkNewPasswordTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(checkNewPasswordTextFieldView).inset(8)
            make.top.equalTo(checkNewPasswordTextFieldView).offset(16)
            make.bottom.equalTo(checkNewPasswordTextFieldView).inset(4)
        }
        
        originePasswordSecureButton.snp.makeConstraints { make in
            make.trailing.equalTo(originePasswordTextFieldView).inset(8)
            make.centerY.equalTo(originePasswordTextFieldView)
        }
        
        newPasswordSecureButton.snp.makeConstraints { make in
            make.trailing.equalTo(newPasswordTextFieldView).inset(8)
            make.centerY.equalTo(newPasswordTextFieldView)
        }
        
        checkNewPasswordSecureButton.snp.makeConstraints { make in
            make.trailing.equalTo(checkNewPasswordTextFieldView).inset(8)
            make.centerY.equalTo(checkNewPasswordTextFieldView)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginStackView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
}

extension ProfileResetPasswordView {
    
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
    
    func setButton(_ isEnabled: Bool) {
        resetPasswordButton.backgroundColor = isEnabled ? .myAppMain : .myAppDarkGray
        resetPasswordButton.isEnabled = isEnabled
    }
}

private func createInputFieldView() -> UIView {
    let view = UIView()
    view.backgroundColor = .myAppLightGray
    view.layer.cornerRadius = 4
    view.clipsToBounds = true
    return view
}

private func createInputInfoLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = Font.Andong18
    label.textColor = .myAppDarkGray
    return label
}

private func createSecureButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(AppText.Login.passwordShow, for: .normal)
    button.setTitleColor(.myAppDarkGray, for: .normal)
    button.titleLabel?.font = Font.Andong13
    return button
}
