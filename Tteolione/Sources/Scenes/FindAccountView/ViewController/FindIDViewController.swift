//
//  FindIDViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class FindIDViewController: BaseViewController<FindIDView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: FindIDViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension FindIDViewController: View {
    
    func bind(reactor: FindIDReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: FindIDReactor) {
        rootView.userNameInputTextField.rx.text.orEmpty
            .map { FindIDReactor.Action.updateUsername($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.emailInputTextField.rx.text.orEmpty
            .map { FindIDReactor.Action.updateUsername($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { FindIDReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.checkButton.rx.tap
            .map { FindIDReactor.Action.sendAuthButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: FindIDReactor) {
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
    
    func bindNavigation(_ reactor: FindIDReactor) {
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
                owner.delegate?.showFindAuth()
            }
            .disposed(by: disposeBag)
    }
}

extension FindIDViewController: DelegateOwner {
    typealias Delegate = FindIDViewControllerDelegate
}
