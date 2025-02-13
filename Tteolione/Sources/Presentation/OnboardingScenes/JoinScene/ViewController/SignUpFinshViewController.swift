//
//  SignUpFinshViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import ReactorKit
import RxCocoa

final class SignUpFinshViewController: BaseViewController<SignUpFinshView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: JoinCoordinatorDelegate?
    
}

extension SignUpFinshViewController: View {
    
    func bind(reactor: SignUpFinshReactor) {
        bindAction(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: SignUpFinshReactor) {
        rootView.joinButton.rx.tap
            .map { SignUpFinshReactor.Action.signUpFishButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: SignUpFinshReactor) {
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

extension SignUpFinshViewController: DelegateOwner {
    typealias Delegate = JoinCoordinatorDelegate
}
