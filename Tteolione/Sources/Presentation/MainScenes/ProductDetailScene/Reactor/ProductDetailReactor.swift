//
//  ProductDetailReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/11/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ProductDetailReactor: Reactor {
    
    enum Action {
        case fetchProductDetail
    }
    
    enum Mutation {
        case setProducts(ProductDetailDTO)
        case showError(NetworkError)
    }

    struct State {
        var productId: Int = 0
        var products: ProductDetailDTO?
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>,
         productId: Int) {
        self.networkProvider = networkProvider
        self.initialState = State(productId: productId)
    }
    
}

extension ProductDetailReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProductDetail:
            return .concat([
                fetchGetProduct(currentState.productId)
            ])
        }
    }
    
}

extension ProductDetailReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProducts(let products):
            newState.products = products
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension ProductDetailReactor {
    
    private func fetchGetProduct(_ productId: Int) -> Observable<Mutation> {
        return networkProvider.request(.getDetailProduct(productId: productId),
                                       decodingType: ServerResponse<ProductDetailDTO>.self)
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
