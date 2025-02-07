//
//  MyProductListViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import ReactorKit
import RxCocoa

final class MyProductListViewController: BaseViewController<MyProductListView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ProfileCoordinatorDelegate?
    
}

extension MyProductListViewController: View {
    
    func bind(reactor: MyProductListReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: MyProductListReactor) {
        self.rx.viewWillAppear
            .map { _ in MyProductListReactor.Action.fetchList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .map { MyProductListReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: MyProductListReactor) {
        reactor.state
            .map { $0.setProductDTO?.content ?? [] }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ProductListTableViewCell.identifier,
                cellType: ProductListTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: MyProductListReactor) {
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

extension MyProductListViewController: DelegateOwner {
    typealias Delegate = ProfileCoordinatorDelegate
}
