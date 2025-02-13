//
//  AuthNumViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/7/24.
//

import ReactorKit
import RxCocoa

final class AuthNumViewController: BaseViewController<AuthNumView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: JoinCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.startTimer)
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
            .map { AuthNumReactor.Action.updateAuthNum($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { AuthNumReactor.Action.authCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AuthNumReactor) {
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
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: AuthNumReactor) {
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
                owner.delegate?.pushNameViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension AuthNumViewController: DelegateOwner {
    typealias Delegate = JoinCoordinatorDelegate
}
