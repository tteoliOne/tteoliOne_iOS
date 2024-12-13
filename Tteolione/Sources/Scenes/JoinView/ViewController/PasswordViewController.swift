//
//  PasswordViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class PasswordViewController: BaseViewController<PasswordView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = PasswordReactor()
    }
    
}

extension PasswordViewController: View {
    
    func bind(reactor: PasswordReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: PasswordReactor) {
        rootView.passwordInputTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PasswordReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { PasswordReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.joinButton.rx.tap
            .map { PasswordReactor.Action.passwordCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: PasswordReactor) {
        reactor.state.map { $0.validations }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, validations in
                for (index, isValid) in validations.enumerated() {
                    let view = owner.rootView.passwordExplainViews[index]
                    view.updateState(isValid: isValid)
                }
                let allValid = validations.allSatisfy { $0 }
                owner.rootView.joinButton.backgroundColor = allValid ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(allValid ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = allValid
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: PasswordReactor) {
        reactor.backNavigation
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.navigateToNextView
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigateToScreen(NicknameViewController())
            }
            .disposed(by: disposeBag)
    }
}
