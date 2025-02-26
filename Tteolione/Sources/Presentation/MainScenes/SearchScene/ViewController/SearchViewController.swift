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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reactor = reactor {
            reactor.action.onNext(.performSearch(reactor.currentState.query))
        }
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
                    reactor.action.onNext(.updateQuery(""))
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
                self.rootView.searchBar.resignFirstResponder()
                self.delegate?.switchToResults(with: [], in: self, query: query)
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
                if suggestions.isEmpty && self.rootView.searchBar.text?.isEmpty == true {
                    self.delegate?.switchToRecentSearch(in: self)
                } else {
                    self.delegate?.switchToSuggestions(with: suggestions, in: self)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.results }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }
                self.delegate?.switchToResults(with: results,
                                               in: self,
                                               query: reactor.currentState.query)
            })
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        delegate?.switchToResults(with: [], in: self, query: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            reactor?.action.onNext(.updateQuery(""))
            delegate?.switchToRecentSearch(in: self)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            delegate?.switchToRecentSearch(in: self)
        }
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

        let existingResults = reactor?.currentState.results ?? []
        delegate?.switchToResults(with: existingResults, in: self, query: suggestion)
    }
}

extension SearchViewController: RecentSearchDelegate {
    func didSelectRecentSearch(_ query: String) {
        rootView.searchBar.text = query
        UserDefaultsStorage.addRecentSearch(query)
        reactor?.action.onNext(.performSearch(query))

        let existingResults = reactor?.currentState.results ?? []
        delegate?.switchToResults(with: existingResults, in: self, query: query)
    }
}
