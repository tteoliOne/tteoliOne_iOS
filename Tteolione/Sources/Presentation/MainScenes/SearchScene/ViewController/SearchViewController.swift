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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    private func setupSearchController() {
        rootView.searchBar.frame = CGRect(x: 0, y: 0, width: Device.screenWidth - 28, height: 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rootView.searchBar)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        rootView.searchBar.placeholder = "검색어를 입력하세요"
    }
}

extension SearchViewController: View {
    
    func bind(reactor: SearchReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: SearchReactor) {
        rootView.searchBar.rx.text.orEmpty
                .distinctUntilChanged()
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .do(onNext: { query in
                    print("Search Query: \(query)") // 디버깅용
                })
                .map { SearchReactor.Action.updateQuery($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        rootView.searchBar.rx.searchButtonClicked
            .withLatestFrom(reactor.state.map { $0.query })
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
    
    func bindNavigation(_ reactor: SearchReactor) {
        
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
