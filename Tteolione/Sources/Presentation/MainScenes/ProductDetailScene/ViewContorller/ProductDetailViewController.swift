//
//  ProductDetailViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/11/25.
//

import ReactorKit
import RxCocoa

final class ProductDetailViewController: BaseViewController<ProductDetailView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?
    
}

extension ProductDetailViewController: View {
    
    func bind(reactor: ProductDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ProductDetailReactor) {
        reactor.action.onNext(.fetchProductDetail)
        
        rootView.receiptButton.rx.tap
            .map { ProductDetailReactor.Action.receiptTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.likeButton.rx.tap
            .map { ProductDetailReactor.Action.likeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProductDetailReactor) {
        reactor.state.map { $0.products }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView, onNext: { owner, value in
                owner.updateUI(with: value)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isReceiptTapped }
            .distinctUntilChanged()
            .bind(with: rootView) { owner, isTapped in
                owner.toggleReceiptPopup(isVisible: isTapped)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { ($0.isLiked, $0.likeCount) }
            .distinctUntilChanged { $0 == $1 }
            .bind(with: rootView) { owner, likeData in
                owner.updateLikeButton(isLiked: likeData.0, likeCount: likeData.1)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ProductDetailReactor) {
        
    }
}

extension ProductDetailViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
