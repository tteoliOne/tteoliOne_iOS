//
//  ReviewPopViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import ReactorKit
import RxCocoa

final class ReviewPopViewController: BaseViewController<ReviewPopView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ChattingCoordinatorDelegate?
    
}

extension ReviewPopViewController: View {
    
    func bind(reactor: ReviewPopReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ReviewPopReactor) {
        rootView.descriptionTextView.rx.text.orEmpty
            .map { $0.count <= 100 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
                if !isEditable {
                    self?.rootView.descriptionTextView.text = String(self?.rootView.descriptionTextView.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        rootView.descriptionTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { ReviewPopReactor.Action.updateDescriptionText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.chevronUpButton.rx.tap
            .map { ReviewPopReactor.Action.chevronUpTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.chevronDownButton.rx.tap
            .map { ReviewPopReactor.Action.chevronDownTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.submitButton.rx.tap
            .map { ReviewPopReactor.Action.submitTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backgroundView.rx.tapGesture()
            .when(.recognized)
            .map { _ in ReviewPopReactor.Action.backgroundTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ReviewPopReactor) {
        reactor.state.map { $0.lengthText }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.remainCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEnabled in
                owner.rootView.setButton(isEnabled)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.score)" }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.scoreLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func bindNavigation(_ reactor: ReviewPopReactor) {
        reactor.state.map { $0.isSubmitTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.dismissVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBackgroundTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.dismissVC()
            }
            .disposed(by: disposeBag)
    }

}

extension ReviewPopViewController: DelegateOwner {
    typealias Delegate = ChattingCoordinatorDelegate
}
