//
//  FindIDResultViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class FindIDResultViewController: BaseViewController<FindIDResultView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ResetPasswordCoordinator?
    
}

extension FindIDResultViewController: View {
    
    func bind(reactor: FindIDResultReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: FindIDResultReactor) {
        rootView.changePasswordButton.rx.tap
            .map { FindIDResultReactor.Action.resetPasswordButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.loginButton.rx.tap
            .map { FindIDResultReactor.Action.LoginHomeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: FindIDResultReactor) {
        reactor.state.map { $0.resultID }
            .distinctUntilChanged()
            .bind(to: rootView.resultIDLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: FindIDResultReactor) {
        reactor.state.map { $0.navigateToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushResetPasswordChcekViewController()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.navigateToLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.finish()
            }
            .disposed(by: disposeBag)
    }
    
}

extension FindIDResultViewController: DelegateOwner {
    typealias Delegate = ResetPasswordCoordinator
}
