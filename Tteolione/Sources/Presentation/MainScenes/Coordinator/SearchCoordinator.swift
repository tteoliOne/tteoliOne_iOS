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
        configureSearchBar(for: viewController)
        show(viewController)
        
        viewController.addChild(recentSearchVC, to: viewController.rootView.childContainerView)
    }
    
    private func configureSearchBar(for viewController: SearchViewController) {
        viewController.rootView.searchBar.frame = CGRect(x: 0, y: 0, width: Device.screenWidth - 28, height: 20)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewController.rootView.searchBar)
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        viewController.definesPresentationContext = true
        viewController.rootView.searchBar.placeholder = "검색어를 입력하세요"
    }
    
    func switchToRecentSearch(in viewController: SearchViewController) {
        recentSearchVC.delegate = viewController
        switchChildViewController(to: recentSearchVC, in: viewController)
    }
    
    func switchToSuggestions(with suggestions: [String], in viewController: SearchViewController) {
        searchSuggestionsVC.updateSearchQuery(with: suggestions)
        searchSuggestionsVC.delegate = viewController
        switchChildViewController(to: searchSuggestionsVC, in: viewController)
    }

    func switchToResults(with results: [ProductPreviewDTO],
                         in viewController: SearchViewController,
                         query: String) {
        searchResultsVC.updateSearchResults(with: results,
                                            query: query)
        searchResultsVC.reactor = viewController.reactor
        searchResultsVC.delegate = self
        switchChildViewController(to: searchResultsVC, in: viewController)
    }
    
    private func switchChildViewController(to newVC: UIViewController, in parentVC: SearchViewController) {
        parentVC.children.forEach { childVC in
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        parentVC.addChild(newVC)
        newVC.view.frame = parentVC.rootView.childContainerView.bounds
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parentVC.rootView.childContainerView.addSubview(newVC.view)
        
        newVC.didMove(toParent: parentVC)
    }
    
    func pushDetailViewController(productId: Int) {
        let coordinator = ProductDetailCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   productId: productId)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
