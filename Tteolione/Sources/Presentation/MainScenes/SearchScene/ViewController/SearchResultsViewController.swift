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
    private let results = BehaviorRelay<[ProductPreviewDTO]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        results
            .bind(to: rootView.tableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier,
                                                  cellType: SearchResultTableViewCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
                                                  .disposed(by: disposeBag)
    }
    
    func updateSearchResults(with results: [ProductPreviewDTO]) {
        self.results.accept(results)
    }

}
