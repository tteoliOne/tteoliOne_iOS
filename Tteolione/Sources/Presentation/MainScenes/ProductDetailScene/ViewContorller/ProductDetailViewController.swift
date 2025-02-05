//
//  ProductDetailViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/11/25.
//

import ReactorKit
import RxCocoa
import UIKit

final class ProductDetailViewController: BaseNavigationViewController<ProductDetailView> {
    
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
            .bind(with: self, onNext: { owner, value in
                owner.setupNavigation(with: value)
                owner.rootView.updateUI(with: value)
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
        reactor.state.map { $0.isDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - 네비게이션 상단바 설정
extension ProductDetailViewController {
    
    private func setupNavigation(with productDetail: ProductDetailDTO) {
        let isOwner = productDetail.checkOwner
        let menu = createMenu(isOwner: isOwner)
        
        let ellipsisButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis")?.rotate(radians: .pi / 2),
            menu: menu
        )
        navigationItem.rightBarButtonItem = ellipsisButton
    }
    
    private func createMenu(isOwner: Bool) -> UIMenu {
        if isOwner {
            let editAction = UIAction(
                title: "수정하기",
                image: UIImage(systemName: "pencil.circle")
            ) { _ in
                print("수정하기 눌림")
            }
            let deleteAction = UIAction(
                title: "삭제하기",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                self?.reactor?.action.onNext(.deletePost)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        } else {
            let reportAction = UIAction(
                title: "신고하기",
                image: UIImage(systemName: "exclamationmark.circle")
            ) { _ in
                print("신고하기 눌림")
            }
            return UIMenu(title: "", children: [reportAction])
        }
    }
}

extension ProductDetailViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
