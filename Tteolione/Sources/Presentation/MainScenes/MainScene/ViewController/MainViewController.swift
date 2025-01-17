//
//  MainViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class MainViewController: BaseViewController<MainView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.merge(
            rootView.tableView.rx.contentOffset.map { $0.y }
        )
        .bind(with: self) { owner, offset in
            owner.rootView.adjustButtonShape(forScrollOffset: offset)
        }
        .disposed(by: disposeBag)
    }
    
}

extension MainViewController: View {
    
    func bind(reactor: MainReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: MainReactor) {
        reactor.action.onNext(.fetchProducts)
    }
    
    func bindState(_ reactor: MainReactor) {
        Observable.combineLatest(
            reactor.state.map { $0.categories }.distinctUntilChanged(),
            reactor.state.map { $0.products }.distinctUntilChanged()
        )
        .map { categories, products in
            zip(categories, products.flatMap { $0.list })
        }
        .observe(on: MainScheduler.instance)
        .bind(to: rootView.tableView.rx.items(
            cellIdentifier: MainTableViewCell.identifier,
            cellType: MainTableViewCell.self
        )) { _, sectionData, cell in
            let (category, productList) = sectionData
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
    }
    
    func bindNavigation(_ reactor: MainReactor) {
        
    }
}

extension MainViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
