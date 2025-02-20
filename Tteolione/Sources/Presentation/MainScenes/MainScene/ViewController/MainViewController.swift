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
        
        rootView.postButton.rx.tap
            .map { MainReactor.Action.postButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.willDisplayCell
            .compactMap { cell, indexPath -> MainTableViewCell? in
                return cell as? MainTableViewCell
            }
            .subscribe(onNext: { tableViewCell in
                tableViewCell.likeButtonTapped
                    .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
                    .subscribe(onNext: { productId in
                        reactor.action.onNext(.likeButtonTap(productId))
                    })
                    .disposed(by: tableViewCell.disposeBag)
            })
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
                cell.collectionView.rx.itemSelected
                    .subscribe(onNext: { [weak self] indexPath in
                        let selectedProduct = productList.products[indexPath.item]
                        self?.delegate?.pushProductDetailView(productId: selectedProduct.productId)
                    })
                    .disposed(by: cell.disposeBag)
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
            .bind(with: rootView) { owner, offset in
                owner.adjustButtonShape(forScrollOffset: offset)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: MainReactor) {
        reactor.state.map { $0.navigateToPost }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushPostViewController(viewType: .post,
                                                       productDetail: nil)
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
