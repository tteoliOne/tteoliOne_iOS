//
//  MainViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import ReactorKit
import RxCocoa
import UIKit

final class MainViewController: BaseViewController<MainView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?
    
}

extension MainViewController: View {
    
    func bind(reactor: MainReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: MainReactor) {
        self.rx.viewWillAppear
            .map { _ in MainReactor.Action.fetchProducts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: MainReactor) {
        reactor.state.map { $0.products }
            .distinctUntilChanged()
            .map { products in
                products.flatMap { $0.list }
            }
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self
            )) { _, productList, cell in
                cell.selectionStyle = .none
                cell.configure(productList: productList)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.contentOffset
            .map { $0.y }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, offset in
                owner.rootView.adjustButtonShape(forScrollOffset: offset)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: MainReactor) {
        
    }
}

extension MainViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
