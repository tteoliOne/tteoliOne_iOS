//
//  EmailAuthViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class EmailAuthViewController: BaseViewController<EmailAuthView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = EmailAuthReactor(networkProvider: NetworkProvider<JoinAPI>())
    }
    
}

extension EmailAuthViewController: View {
    
    func bind(reactor: EmailAuthReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: EmailAuthReactor) {
        rootView.emailInputTextField.rx.text.orEmpty
            .map { EmailAuthReactor.Action.emailInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { EmailAuthReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.joinButton.rx.tap
            .map { EmailAuthReactor.Action.emailCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: EmailAuthReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: EmailAuthReactor) {
        reactor.backNavigation
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.navigateToNextView
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigateToScreen(AuthNumViewController())
            }
            .disposed(by: disposeBag)
    }
}
