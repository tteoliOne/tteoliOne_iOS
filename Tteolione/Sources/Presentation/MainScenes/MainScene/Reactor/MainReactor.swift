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
        case postButtonTap
        case likeButtonTap(Int)
    }
    
    enum Mutation {
        case setProducts(ProductDTO)
        case showError(NetworkError)
        case setNavigateToPost(Bool)
        case setProductId([Int])
        case setProcessingLike(Bool)
    }
    
    struct State {
        var products: [ProductDTO] = []
        var errorMessage: String?
        var navigateToPost: Bool = false
        var productIds: [Int] = []
        var isProcessingLike: Bool = false
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
            
        case .postButtonTap:
            return .concat([
                .just(.setNavigateToPost(true)),
                .just(.setNavigateToPost(false))
            ])
            
        case .likeButtonTap(let productId):
            guard !currentState.isProcessingLike else { return .empty() }
            return .concat([
                fetchLikePost(productId: productId)
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
            
        case .setNavigateToPost(let isNavi):
            newState.navigateToPost = isNavi
            
        case .setProductId(let ids):
            newState.productIds = ids
            
        case .setProcessingLike(let isProcessing):
            newState.isProcessingLike = isProcessing
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
                let productIds = dto.list.flatMap { $0.products.map { $0.productId } }
                return .concat([
                    .just(.setProductId(productIds)),
                    .just(.setProducts(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchLikePost(productId: Int) -> Observable<Mutation> {
        return networkProvider.request(.likeProduct(productId: productId),
                                       decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
                    .just(.setProcessingLike(true)),
                    .just(.setProcessingLike(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
