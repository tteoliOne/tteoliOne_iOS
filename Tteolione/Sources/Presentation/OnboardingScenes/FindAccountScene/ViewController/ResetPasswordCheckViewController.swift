//
//  ResetPasswordCheckViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import ReactorKit
import RxCocoa

final class ResetPasswordCheckViewController: BaseViewController<ResetPasswordCheckView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: FindAccountCoordinatorDelegate?
    
}

extension ResetPasswordCheckViewController: View {
    
    func bind(reactor: ResetPasswordCheckReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ResetPasswordCheckReactor) {
        rootView.userNameInputTextField.rx.text.orEmpty
            .map { ResetPasswordCheckReactor.Action.updateUsername($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.idInputTextField.rx.text.orEmpty
            .map { ResetPasswordCheckReactor.Action.updateId($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.emailInputTextField.rx.text.orEmpty
            .map { ResetPasswordCheckReactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { ResetPasswordCheckReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { ResetPasswordCheckReactor.Action.sendAuthButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ResetPasswordCheckReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                let isAllEnabled = isEnabled.allSatisfy { $0 }
                owner.rootView.setButton(isAllEnabled)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ResetPasswordCheckReactor) {
        reactor.state
            .map { ($0.navigateBack, $0.viewType) }
            .distinctUntilChanged { $0.0 == $1.0 }
            .filter { $0.0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, data in
                guard let viewType = data.1 else { return }
                switch viewType {
                case .id, .idInPassword:
                    owner.delegate?.popVC()
                case .password:
                    owner.delegate?.finishView()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.navigateToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushAuthViewController(viewType: .password)
            }
            .disposed(by: disposeBag)
    }
}

extension ResetPasswordCheckViewController: DelegateOwner {
    typealias Delegate = FindAccountCoordinatorDelegate
}
