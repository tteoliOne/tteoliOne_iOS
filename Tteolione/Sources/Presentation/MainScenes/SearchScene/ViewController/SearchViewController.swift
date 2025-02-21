//
//  SearchViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class SearchViewController: BaseViewController<SearchView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SearchCoordinatorDelegate?
    
    override func setupKeyboardDismissGesture() {
        super.setupKeyboardDismissGesture()
    }
}

extension SearchViewController: View {
    
    func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: SearchReactor) {
        rootView.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .do(onNext: { query in
                if query.isEmpty {
                    self.delegate?.switchToRecentSearch(in: self)
                }
            })
            .map { SearchReactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.searchBar.rx.searchButtonClicked
            .withLatestFrom(reactor.state.map { $0.query })
            .do(onNext: { query in
                UserDefaultsStorage.addRecentSearch(query)
                NotificationCenter.default.post(name: .recentSearchUpdated, object: nil)
            })
            .map { SearchReactor.Action.performSearch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SearchReactor) {
        reactor.state.map { $0.suggestions }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] suggestions in
                guard let self = self else { return }
                self.delegate?.switchToSuggestions(with: suggestions, in: self)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.results }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }
                self.delegate?.switchToResults(with: results, in: self)
            })
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        delegate?.switchToResults(with: [], in: self)
    }
}

extension SearchViewController: DelegateOwner {
    typealias Delegate = SearchCoordinatorDelegate
}

extension SearchViewController: SearchSuggestionsDelegate {
    func didSelectSuggestion(_ suggestion: String) {
        rootView.searchBar.text = suggestion
        UserDefaultsStorage.addRecentSearch(suggestion)
        reactor?.action.onNext(.performSearch(suggestion))
    }
}

extension SearchViewController: RecentSearchDelegate {
    func didSelectRecentSearch(_ query: String) {
        rootView.searchBar.text = query
        reactor?.action.onNext(.performSearch(query))
    }
}
