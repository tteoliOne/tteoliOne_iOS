//
//  NameViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/28/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class NameViewController: BaseViewController<NameView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: NameViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NameViewController: View {
    
    func bind(reactor: NameReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: NameReactor) {
        rootView.nameInputTextField.rx.text.orEmpty
            .map { NameReactor.Action.usernameInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { NameReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.joinButton.rx.tap
            .map { NameReactor.Action.usernameCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: NameReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: NameReactor) {
        reactor.state.map { $0.navigateBack }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popToPreviousScreen()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.navigateToNext }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showID()
            }
            .disposed(by: disposeBag)
    }
}

extension NameViewController: DelegateOwner {
    typealias Delegate = NameViewControllerDelegate
}
