//
//  SearchSuggestionsViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchSuggestionsViewController: BaseViewController<SearchSuggestionsView> {
    
    private let disposeBag = DisposeBag()
    private let suggestions = BehaviorRelay<[String]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        suggestions
            .bind(to: rootView.tableView.rx.items(cellIdentifier: "SuggestionCell", cellType: UITableViewCell.self)) { _, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
    }
    
    func updateSearchQuery(with suggestions: [String]) {
        self.suggestions.accept(suggestions)
    }
    
}
