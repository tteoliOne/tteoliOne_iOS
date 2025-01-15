//
//  AuthViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class AuthViewController: BaseViewController<AuthView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension AuthViewController: View {
    
    func bind(reactor: AuthReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: AuthReactor) {
        rootView.topBarView.backButton.rx.tap
            .map { AuthReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.authNumInputTextField.rx.text.orEmpty
            .map { AuthReactor.Action.updateAuthNum($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { AuthReactor.Action.authCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AuthReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.setButton(isEnabled)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.remainingTime }
            .distinctUntilChanged()
            .bind(to: rootView.explanationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: AuthReactor) {
        reactor.state.map { $0.navigateBack }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.navigateToNext }
//            .distinctUntilChanged()
//            .filter { $0 }
            .compactMap{ $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dto in
                owner.delegate?.showFindIDResult(with: dto)
            }
            .disposed(by: disposeBag)
    }
}

extension AuthViewController: DelegateOwner {
    typealias Delegate = AuthViewControllerDelegate
}
