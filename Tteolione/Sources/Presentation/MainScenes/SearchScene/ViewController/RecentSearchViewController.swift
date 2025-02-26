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
    private let recentSearches = BehaviorRelay<[String]>(value: UserDefaultsStorage.recentSearches)
    weak var delegate: RecentSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateRecentSearches),
                                               name: .recentSearchUpdated,
                                               object: nil)
    }
    
    @objc private func updateRecentSearches() {
        recentSearches.accept(UserDefaultsStorage.recentSearches)
    }
    
    private func bind() {
        recentSearches
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: RecentSearchTableViewCell.identifier,
                cellType: RecentSearchTableViewCell.self)) { row, element, cell in
                    cell.configure(with: element)
                    
                    cell.deleteButton.rx.tap
                        .subscribe(onNext: { [weak self] in
                            self?.removeSearchTerm(element)
                        })
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] selectedSearch in
                UserDefaultsStorage.addRecentSearch(selectedSearch)
                self?.delegate?.didSelectRecentSearch(selectedSearch)
                DispatchQueue.main.async {
                    self?.rootView.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func removeSearchTerm(_ term: String) {
        UserDefaultsStorage.removeRecentSearch(term)
        recentSearches.accept(UserDefaultsStorage.recentSearches)
    }
}
