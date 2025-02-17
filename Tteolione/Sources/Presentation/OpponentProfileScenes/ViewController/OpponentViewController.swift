//
//  OpponentViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/16/25.
//

import ReactorKit
import RxCocoa
import UIKit

final class OpponentViewController: BaseViewController<OpponentView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: OpponentCoordinatorDelegate?
    
}

extension OpponentViewController: View {
    
    func bind(reactor: OpponentReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: OpponentReactor) {
        self.rx.viewWillAppear
            .map { _ in OpponentReactor.Action.fetchOpponent }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.segmentControl.selectionChanged = { selectedIndex in
            reactor.action.onNext(.segmentChanged(selectedIndex))
        }
        
        rootView.backButton.rx.tap
            .map { OpponentReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: OpponentReactor) {
        reactor.state.map { $0.otherUserDTO }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, value in
                owner.rootView.updateUI(with: value)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedSegmentIndex }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, index in
                owner.rootView.collectionView.isHidden = index == 2
                owner.rootView.tableView.isHidden = index != 2
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.opponentProducts }
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.collectionView.rx.items(
                cellIdentifier: OpponentCollectionViewCell.identifier,
                cellType: OpponentCollectionViewCell.self)
            ) { index, product, cell in
                cell.product = product
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.otherReviewsDTO }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ReviewTableViewCell.identifier,
                cellType: ReviewTableViewCell.self)
            ) { index, review, cell in
                cell.setUI(review)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: OpponentReactor) {
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension OpponentViewController: DelegateOwner {
    typealias Delegate = OpponentCoordinatorDelegate
}
