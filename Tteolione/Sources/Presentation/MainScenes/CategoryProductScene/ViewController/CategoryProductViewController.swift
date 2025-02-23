//
//  CategoryProductViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class CategoryProductViewController: BaseViewController<CategoryProductView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?

}

extension CategoryProductViewController: View {
    
    func bind(reactor: CategoryProductReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: CategoryProductReactor) {
        self.rx.viewWillAppear
            .map { _ in CategoryProductReactor.Action.fetchProduct }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.filterButton.rx.tap
            .map { CategoryProductReactor.Action.toggleSortOrder }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.willDisplayCell
            .filter { [weak self] (_, indexPath) in
                guard let self = self else { return false }
                let lastRowIndex = self.rootView.tableView.numberOfRows(inSection: indexPath.section) - 1
                return indexPath.row == lastRowIndex
            }
            .map { _ in CategoryProductReactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(ProductPreviewDTO.self)
            .filter { $0.soldStatus != "eSoldOut" }
            .map { CategoryProductReactor.Action.selectProduct($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.willDisplayCell
                .compactMap { cell, indexPath -> (ProductListTableViewCell, IndexPath)? in
                    guard let productCell = cell as? ProductListTableViewCell else { return nil }
                    return (productCell, indexPath)
                }
                .subscribe(onNext: { (cell, indexPath) in
                    cell.likeButtonTapped
                        .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
                        .subscribe(onNext: { productId in
                            reactor.action.onNext(.toggleLike(productId))
                        })
                        .disposed(by: cell.disposeBag)
                })
                .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: CategoryProductReactor) {
        reactor.state
            .map { $0.product?.content ?? [] }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ProductListTableViewCell.identifier,
                cellType: ProductListTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.product = item
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.categoryId ?? 0 }
            .distinctUntilChanged()
            .bind(with: rootView, onNext: { owner, id in
                owner.setTitle(id)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sortOrder == "createAt-desc" ? "최신순" : "오래된순" }
            .distinctUntilChanged()
            .bind(to: rootView.filterButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.showToastMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                owner.view.makeToast(value)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: CategoryProductReactor) {
        reactor.state
            .map { ($0.isShowDetailView, $0.selectedProduct) }
            .filter { $0.0 }
            .compactMap { $0.1 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, product in
                owner.delegate?.pushDetailViewController(productId: product.productId)
            }
            .disposed(by: disposeBag)
    }
}

extension CategoryProductViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
