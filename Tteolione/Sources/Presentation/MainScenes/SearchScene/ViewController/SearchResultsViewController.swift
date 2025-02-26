//
//  SearchResultsViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultsViewController: BaseViewController<SearchResultsView> {
    
    private let disposeBag = DisposeBag()
    var reactor: SearchReactor?
    weak var delegate: SearchCoordinatorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reactor = reactor {
            reactor.action.onNext(.performSearch(reactor.currentState.query))
        }
    }

    private func setupBindings() {
        guard let reactor = reactor else { return }

        reactor.state.map { $0.results }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ProductListTableViewCell.identifier,
                cellType: ProductListTableViewCell.self
            )) { _, element, cell in
                cell.product = element
                cell.likeButtonTapped
                    .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
                    .subscribe(onNext: { productId in
                        reactor.action.onNext(.toggleLike(productId))
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.modelSelected(ProductPreviewDTO.self)
            .subscribe(onNext: { [weak self] product in
                guard let self = self else { return }
                self.delegate?.pushDetailViewController(productId: product.productId)
                DispatchQueue.main.async {
                    if let selectedIndexPath = self.rootView.tableView.indexPathForSelectedRow {
                        self.rootView.tableView.deselectRow(at: selectedIndexPath, animated: true)
                    }
                }
            })
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
    
    func updateSearchResults(with results: [ProductPreviewDTO], query: String) {
        rootView.searchLabel.text = "\(query) 검색 결과"
        reactor?.action.onNext(.performSearch(query))
    }

}
