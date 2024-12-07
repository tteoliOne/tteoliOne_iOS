//
//  LoginViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class LoginViewController: BaseViewController<LoginView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = LoginReactor()
    }
    
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
        
    }
    
    private func bindNavigation(_ reactor: LoginReactor) {
        reactor.navigateToSignUp
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigateToScreen(EmailAuthViewController())
            }
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    
    private func navigateToScreen(_ scenes: UIViewController) {
        let viewController = scenes
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
