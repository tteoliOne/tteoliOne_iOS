//
//  ResetPasswordViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import ReactorKit
import RxCocoa

final class ResetPasswordViewController: BaseViewController<ResetPasswordView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: FindAccountCoordinator?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
    }
}

extension ResetPasswordViewController: View {
    
    func bind(reactor: ResetPasswordReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: ResetPasswordReactor) {
        rootView.passwordInputTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { ResetPasswordReactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { ResetPasswordReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.completeResetButton.rx.tap
            .map { ResetPasswordReactor.Action.passwordResetButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ResetPasswordReactor) {
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
    
    private func bindNavigation(_ reactor: ResetPasswordReactor) {
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
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension ResetPasswordViewController: DelegateOwner {
    typealias Delegate = FindAccountCoordinator
}
