//
//  RecentSearchViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RecentSearchViewController: BaseViewController<RecentSearchView> {
    
    private let disposeBag = DisposeBag()
    private let recentSearches = BehaviorRelay<[String]>(value: ["Apple", "Banana", "Carrot"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        recentSearches
            .bind(to: rootView.tableView.rx.items(cellIdentifier: RecentSearchTableViewCell.identifier,
                                                  cellType: RecentSearchTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] selectedSearch in
                print("Selected Search: \(selectedSearch)")
            })
            .disposed(by: disposeBag)
    }
}
