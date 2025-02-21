//
//  MyReviewViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import ReactorKit
import RxCocoa

final class MyReviewViewController: BaseViewController<MyReviewView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ProfileCoordinatorDelegate?
    
}

extension MyReviewViewController: View {
    
    func bind(reactor: MyReviewReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: MyReviewReactor) {
        self.rx.viewWillAppear
            .map { _ in MyReviewReactor.Action.fetchReview }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .map { MyReviewReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: MyReviewReactor) {
        reactor.state
            .map { $0.reviewDTO ?? [] }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ReviewTableViewCell.identifier,
                cellType: ReviewTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.setUI(item)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: MyReviewReactor) {
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
    }
}

extension MyReviewViewController: DelegateOwner {
    typealias Delegate = ProfileCoordinatorDelegate
}
