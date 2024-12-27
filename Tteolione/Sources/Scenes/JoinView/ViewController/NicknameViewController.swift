//
//  NicknameViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class NicknameViewController: BaseViewController<NicknameView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: NicknameViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        rootView.joinButton.rx.tap
            .map { NicknameReactor.Action.nicknameCheckButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: NicknameReactor) {
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.joinButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
                owner.rootView.joinButton.setTitleColor(isEnabled ? .white : .myAppBlack, for: .normal)
                owner.rootView.joinButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: NicknameReactor) {
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
                owner.delegate?.showProfileSet()
            }
            .disposed(by: disposeBag)
    }
}

extension NicknameViewController: DelegateOwner {
    typealias Delegate = NicknameViewControllerDelegate
}
