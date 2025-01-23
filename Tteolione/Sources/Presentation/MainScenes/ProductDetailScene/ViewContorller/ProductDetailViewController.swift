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
//        bindAction(reactor)
//        bindState(reactor)
//        bindNavigation(reactor)
    }
    
}

extension ProductDetailViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
