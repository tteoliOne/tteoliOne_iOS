//
//  PasswordViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import ReactorKit
import RxCocoa

final class PasswordViewController: BaseViewController<PasswordView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: JoinCoordinatorDelegate?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
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
        
        rootView.checkButton.rx.tap
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
                owner.rootView.setButton(allValid)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: PasswordReactor) {
        reactor.state.map { $0.navigateBack }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.navigateToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushNicknameViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension PasswordViewController: DelegateOwner {
    typealias Delegate = JoinCoordinatorDelegate
}
