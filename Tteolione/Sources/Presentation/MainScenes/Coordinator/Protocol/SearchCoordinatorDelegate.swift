//
//  SearchCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import Foundation

protocol SearchCoordinatorDelegate: Coordinator {
    func switchToRecentSearch(in viewController: SearchViewController)
    func switchToSuggestions(with suggestions: [String], in viewController: SearchViewController)
    func switchToResults(with results: [ProductPreviewDTO], in viewController: SearchViewController, query: String)
    func pushDetailViewController(productId: Int)
}
