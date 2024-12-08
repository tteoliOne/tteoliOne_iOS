//
//  AuthNumViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/7/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class AuthNumViewController: BaseViewController<AuthNumView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = AuthNumReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.startTimer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reactor?.action.onNext(.stopTimer)
    }
    
}

extension AuthNumViewController: View {
    
    func bind(reactor: AuthNumReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: AuthNumReactor) {
        rootView.topBarView.backButton.rx.tap
            .map { AuthNumReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.authNumInputTextField.rx.text.orEmpty
            .map { AuthNumReactor.Action.authNumTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AuthNumReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.remainingTime }
            .distinctUntilChanged()
            .bind(to: rootView.explanationLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: AuthNumReactor) {
        reactor.backNavigation
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
