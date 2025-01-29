//
//  SearchDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/30/25.
//

import Foundation

protocol SearchSuggestionsDelegate: AnyObject {
    func didSelectSuggestion(_ suggestion: String)
}

protocol RecentSearchDelegate: AnyObject {
    func didSelectRecentSearch(_ query: String)
}
