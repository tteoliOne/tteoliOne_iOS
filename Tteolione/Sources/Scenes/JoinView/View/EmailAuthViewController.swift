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
        self.reactor = EmailAuthReactor()
    }
    
}

extension EmailAuthViewController: View {
    
    func bind(reactor: EmailAuthReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: EmailAuthReactor) {
        rootView.emailInputTextField.rx.text.orEmpty
            .map { EmailAuthReactor.Action.emailInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: EmailAuthReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
    }
    
}
