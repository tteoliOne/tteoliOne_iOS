//
//  ProfileResetPasswordViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import ReactorKit
import RxSwift
import RxCocoa
import Toast

final class ProfileResetPasswordViewController: BaseViewController<ProfileResetPasswordView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SettingCoordinatorDelegate?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
    }
}

extension ProfileResetPasswordViewController: View {
    
    func bind(reactor: ProfileResetPasswordReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ProfileResetPasswordReactor) {
        rootView.originePasswordTextField.rx.text.orEmpty
            .map { ProfileResetPasswordReactor.Action.updateOriginalPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.newPasswordTextField.rx.text.orEmpty
            .map { ProfileResetPasswordReactor.Action.updateNewPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkNewPasswordTextField.rx.text.orEmpty
            .map { ProfileResetPasswordReactor.Action.updateConfirmPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.originePasswordTextField.rx.controlEvent(.touchDown)
            .map { ProfileResetPasswordReactor.Action.originalPasswordTextFieldTapBegin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.originePasswordTextField.rx.controlEvent(.editingDidEnd)
            .map { ProfileResetPasswordReactor.Action.originalPasswordTextFieldTapEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.newPasswordTextField.rx.controlEvent(.touchDown)
            .map { ProfileResetPasswordReactor.Action.newPasswordTextFieldTapBegin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.newPasswordTextField.rx.controlEvent(.editingDidEnd)
            .map { ProfileResetPasswordReactor.Action.newPasswordTextFieldTapEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkNewPasswordTextField.rx.controlEvent(.touchDown)
            .map { ProfileResetPasswordReactor.Action.confirmPasswordTextFieldTapBegin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkNewPasswordTextField.rx.controlEvent(.editingDidEnd)
            .map { ProfileResetPasswordReactor.Action.confirmPasswordTextFieldTapEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.originePasswordSecureButton.rx.tap
            .map { ProfileResetPasswordReactor.Action.originalPasswordSecureButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.newPasswordSecureButton.rx.tap
            .map { ProfileResetPasswordReactor.Action.newPasswordSecureButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkNewPasswordSecureButton.rx.tap
            .map { ProfileResetPasswordReactor.Action.confirmPasswordSecureButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.resetPasswordButton.rx.tap
            .map { ProfileResetPasswordReactor.Action.resetPasswordButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .map { ProfileResetPasswordReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileResetPasswordReactor) {
        reactor.state.map { $0.isOriginalPasswordLabelUp }
            .distinctUntilChanged()
            .bind(with: self) { owner, isUp in
                if isUp {
                    owner.rootView.animateLabelUp(owner.rootView.originePasswordInfoLabel)
                } else {
                    owner.rootView.animateLabelDown(owner.rootView.originePasswordInfoLabel,
                                                    textField: owner.rootView.originePasswordTextField)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNewPasswordLabelUp }
            .distinctUntilChanged()
            .bind(with: self) { owner, isUp in
                if isUp {
                    owner.rootView.animateLabelUp(owner.rootView.newPasswordInfoLabel)
                } else {
                    owner.rootView.animateLabelDown(owner.rootView.newPasswordInfoLabel,
                                                    textField: owner.rootView.newPasswordTextField)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isConfirmPasswordLabelUp }
            .distinctUntilChanged()
            .bind(with: self) { owner, isUp in
                if isUp {
                    owner.rootView.animateLabelUp(owner.rootView.checkNewPasswordInfoLabel)
                } else {
                    owner.rootView.animateLabelDown(owner.rootView.checkNewPasswordInfoLabel,
                                                    textField: owner.rootView.checkNewPasswordTextField)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isOriginalPasswordSecure }
            .distinctUntilChanged()
            .bind(with: self) { owner, isSecure in
                owner.rootView.originePasswordTextField.isSecureTextEntry = isSecure
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNewPasswordSecure }
            .distinctUntilChanged()
            .bind(with: self) { owner, isSecure in
                owner.rootView.newPasswordTextField.isSecureTextEntry = isSecure
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isConfirmPasswordSecure }
            .distinctUntilChanged()
            .bind(with: self) { owner, isSecure in
                owner.rootView.checkNewPasswordTextField.isSecureTextEntry = isSecure
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isResetButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                let isAllEnabled = isEnabled.allSatisfy { $0 }
                owner.rootView.setButton(isAllEnabled)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ProfileResetPasswordReactor) {
        reactor.state.map { $0.isResetSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.view.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileResetPasswordViewController: DelegateOwner {
    typealias Delegate = SettingCoordinatorDelegate
}
