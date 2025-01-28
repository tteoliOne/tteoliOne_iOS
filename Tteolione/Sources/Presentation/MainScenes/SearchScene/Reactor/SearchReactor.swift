//
//  SearchReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import Foundation
import ReactorKit
import RxSwift

final class SearchReactor: Reactor {
    
    enum Action {
        case updateQuery(String)
        case performSearch(String)
    }
    
    enum Mutation {
        case setQuery(String)
        case setSuggestions([String])
        case setResults([ProductPreviewDTO])
        case setLoading(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var query: String = ""
        var suggestions: [String] = []
        var results: [ProductPreviewDTO] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension SearchReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return .concat([
                .just(.setQuery(query)),
                .just(.setLoading(true)),
                fetchSearchResults(for: query, isSuggestion: true),
                .just(.setLoading(false))
            ])
            
        case .performSearch(let query):
            return .concat([
                .just(.setLoading(true)),
                fetchSearchResults(for: query, isSuggestion: false),
                .just(.setLoading(false))
            ])
        }
    }
    
}

extension SearchReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setQuery(let query):
            newState.query = query
            
        case .setSuggestions(let suggestions):
            newState.suggestions = suggestions
            
        case .setResults(let results):
            newState.results = results
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension SearchReactor {
    
    private func fetchSearchResults(for query: String, isSuggestion: Bool) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude

        let queryParams = ProductQueryParameters(longitude: longitude,
                                                 latitude: latitude,
                                                 page: 0,
                                                 size: 5,
                                                 sort: "createAt-desc",
                                                 q: query)
        print("Query Parameters: \(queryParams)")
        return networkProvider.request(.searchProduct(query: queryParams),
                                       decodingType: ServerResponse<ProductSearchDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                if isSuggestion {
                    let suggestions = dto.list.content.map { $0.title }
                    return .just(.setSuggestions(suggestions))
                } else {
                    return .just(.setResults(dto.list.content))
                }
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
