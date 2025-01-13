//
//  IDViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/10/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class IDViewController: BaseViewController<IDView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: IDViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        rootView.joinButton.rx.tap
            .map { IDReactor.Action.idCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: IDReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: IDReactor) {
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
                owner.delegate?.showPassword()
            }
            .disposed(by: disposeBag)
    }
}

extension IDViewController: DelegateOwner {
    typealias Delegate = IDViewControllerDelegate
}
