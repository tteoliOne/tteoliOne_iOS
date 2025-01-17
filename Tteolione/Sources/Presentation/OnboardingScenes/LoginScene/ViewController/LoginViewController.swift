//
//  LoginViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import ReactorKit
import RxCocoa

final class LoginViewController: BaseNavigationViewController<LoginView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: LoginCoordinatorDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension LoginViewController: View {
    
    func bind(reactor: LoginReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: LoginReactor) {
        rootView.emailTextField.rx.text.orEmpty
            .map { LoginReactor.Action.updateId($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.passwordTextField.rx.text.orEmpty
            .map { LoginReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.emailTextField.rx.controlEvent(.touchDown)
            .map { LoginReactor.Action.emailTextFieldTapBegin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.emailTextField.rx.controlEvent(.editingDidEnd)
            .map { LoginReactor.Action.emailTextFieldTapEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.passwordTextField.rx.controlEvent(.touchDown)
            .map { LoginReactor.Action.passwordTextFieldTapBegin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.passwordTextField.rx.controlEvent(.editingDidEnd)
            .map { LoginReactor.Action.passwordTextFieldTapEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.passwordSecureButton.rx.tap
            .map { LoginReactor.Action.passwordSecureButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap
            .map { LoginReactor.Action.signUpButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.idSearchButton.rx.tap
            .map { LoginReactor.Action.idSearchButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.passwordResetButton.rx.tap
            .map { LoginReactor.Action.resetPasswordButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.loginButton.rx.tap
            .map { LoginReactor.Action.loginButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.kakaoLoginButton.rx.tap
            .map { LoginReactor.Action.kakaoButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.appleLoginButton.rx.tap
            .map { LoginReactor.Action.appleButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LoginReactor) {
        reactor.state.map { $0.isEmailLabelUp }
            .distinctUntilChanged()
            .bind(with: self) { owner, isUp in
                if isUp {
                    owner.rootView.animateLabelUp(owner.rootView.emailInfoLabel)
                } else {
                    owner.rootView.animateLabelDown(owner.rootView.emailInfoLabel,
                                                    textField: owner.rootView.emailTextField)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPasswordLabelUp }
            .distinctUntilChanged()
            .bind(with: self) { owner, isUp in
                if isUp {
                    owner.rootView.animateLabelUp(owner.rootView.passwordInfoLabel)
                } else {
                    owner.rootView.animateLabelDown(owner.rootView.passwordInfoLabel,
                                                    textField: owner.rootView.passwordTextField)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPasswordSecure }
            .distinctUntilChanged()
            .bind(with: self) { owner, isSecure in
                owner.rootView.passwordTextField.isSecureTextEntry = isSecure
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoginButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                let isAllEnabled = isEnabled.allSatisfy { $0 }
                owner.rootView.setButton(isAllEnabled)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: LoginReactor) {
        reactor.state.map { $0.isSignUpToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showSignUpView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFindIDToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showFindIDView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPasswordToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showFindPasswordView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoginToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showAddressView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isKakaoLoginToAddress }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showAddressView()
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { ($0.isKakaoLoginToProfile, $0.kakaoProfileToken) }
            .distinctUntilChanged { $0.0 == $1.0 }
            .filter { $0.0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, data in
                let token = data.1
                owner.delegate?.showAddressView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAppleLoginToAddress }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showAddressView()
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isAppleLoginToProfile }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showAddressView()
            }
            .disposed(by: disposeBag)
    }
    
}

extension LoginViewController: DelegateOwner {
    typealias Delegate = LoginCoordinatorDelegate
}
