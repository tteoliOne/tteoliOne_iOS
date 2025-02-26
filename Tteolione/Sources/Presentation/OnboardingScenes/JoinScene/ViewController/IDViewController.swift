//
//  IDViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/10/24.
//

import ReactorKit
import RxCocoa

final class IDViewController: BaseViewController<IDView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: JoinCoordinatorDelegate?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
    }
}

extension IDViewController: View {
    
    func bind(reactor: IDReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: IDReactor) {
        rootView.idInputTextField.rx.text.orEmpty
            .map { IDReactor.Action.idInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { IDReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { IDReactor.Action.idCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: IDReactor) {
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
    
    private func bindNavigation(_ reactor: IDReactor) {
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
                owner.delegate?.pushPasswordViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension IDViewController: DelegateOwner {
    typealias Delegate = JoinCoordinatorDelegate
}
