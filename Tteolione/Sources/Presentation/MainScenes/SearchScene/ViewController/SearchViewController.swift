//
//  SearchViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController<SearchView> {
    
    private let disposeBag = DisposeBag()
    
    private let recentSearchVC = RecentSearchViewController()
    private let searchSuggestionsVC = SearchSuggestionsViewController()
    private let searchResultsVC = SearchResultsViewController()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchController()
        setupInitialChildView()
        bindSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "검색"
        definesPresentationContext = true
    }
    
    private func setupInitialChildView() {
        add(childVC: recentSearchVC)
    }
    
    private func add(childVC: UIViewController) {
        addChild(childVC)
        rootView.setChildView(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    private func remove(childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
    private func switchTo(_ newVC: UIViewController) {
        for child in children {
            remove(childVC: child)
        }
        add(childVC: newVC)
    }
    
    private func bindSearchController() {
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.switchTo(self.recentSearchVC)
                } else {
                    self.searchSuggestionsVC.updateSearchQuery(query)
                    self.switchTo(self.searchSuggestionsVC)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchResultsVC.performSearch(with: query)
        switchTo(searchResultsVC)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
