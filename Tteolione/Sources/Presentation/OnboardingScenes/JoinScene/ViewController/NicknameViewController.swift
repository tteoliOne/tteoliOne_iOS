//
//  NicknameViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import ReactorKit
import RxCocoa

final class NicknameViewController: BaseViewController<NicknameView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: JoinCoordinatorDelegate?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
    }
}

extension NicknameViewController: View {
    
    func bind(reactor: NicknameReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: NicknameReactor) {
        rootView.nicknameInputTextField.rx.text.orEmpty
            .map { NicknameReactor.Action.nicknameInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { NicknameReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { NicknameReactor.Action.nicknameCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: NicknameReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.setButton(isEnabled)
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
    
    private func bindNavigation(_ reactor: NicknameReactor) {
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
                owner.delegate?.pushProfileSetViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension NicknameViewController: DelegateOwner {
    typealias Delegate = JoinCoordinatorDelegate
}
