//
//  SearchCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit

final class SearchCoordinator: SearchCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    
    private let recentSearchVC = RecentSearchViewController()
    private let searchSuggestionsVC = SearchSuggestionsViewController()
    private let searchResultsVC = SearchResultsViewController()
    
    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        pushSearchViewController()
    }
    
}

extension SearchCoordinator {
    
    func pushSearchViewController() {
        let reactor = SearchReactor(networkProvider: dependency.productServiceProvider)
        let viewController = createViewController(
            ofType: SearchViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.delegate = self
        show(viewController)
        
        viewController.addChild(recentSearchVC, to: viewController.rootView.childContainerView)
    }
    
    func switchToRecentSearch(in viewController: SearchViewController) {
        switchChildViewController(to: recentSearchVC, in: viewController)
    }
    
    func switchToSuggestions(with suggestions: [String], in viewController: SearchViewController) {
        searchSuggestionsVC.updateSearchQuery(with: suggestions)
        switchChildViewController(to: searchSuggestionsVC, in: viewController)
    }
    
    func switchToResults(with results: [ProductPreviewDTO], in viewController: SearchViewController) {
        searchResultsVC.updateSearchResults(with: results)
        switchChildViewController(to: searchResultsVC, in: viewController)
    }
    
    private func switchChildViewController(to newVC: UIViewController, in parentVC: SearchViewController) {
        for child in parentVC.children {
            parentVC.removeChild(child)
        }
        parentVC.addChild(newVC, to: parentVC.rootView.childContainerView)
    }
}
