//
//  MainReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MainReactor: Reactor {
    
    enum Action {
        case fetchProducts
    }
    
    enum Mutation {
        case setProducts(ProductDTO)
        case showError(NetworkError)
    }

    struct State {
        var categories: [String] = Constants.productCategories
        var products: [ProductDTO] = []
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension MainReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProducts:
            return .concat([
                fetchProductsPost()
            ])
        }
    }
    
}

extension MainReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProducts(let productDTO):
            newState.products = [productDTO]
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension MainReactor {
    
    private func fetchProductsPost() -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude)
        return networkProvider.request(.getMainProduct(query: query),
                                       decodingType: ServerResponse<ProductDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setProducts(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
