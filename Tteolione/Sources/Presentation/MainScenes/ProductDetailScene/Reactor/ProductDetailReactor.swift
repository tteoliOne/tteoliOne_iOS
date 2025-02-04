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
        case receiptTap
        case likeButtonTap
    }
    
    enum Mutation {
        case setProducts(ProductDetailDTO)
        case showError(NetworkError)
        case toggleReceiptPopup(Bool)
        case toggleLikeButton(Bool, Int)
    }

    struct State {
        var productId: Int = 0
        var products: ProductDetailDTO?
        var errorMessage: String?
        var isReceiptTapped: Bool = false
        var isLiked: Bool = false
        var likeCount: Int = 0
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
            
        case .receiptTap:
            return .just(.toggleReceiptPopup(!currentState.isReceiptTapped))
            
        case .likeButtonTap:
            return fetchLikePost(productId: currentState.productId)
        }
    }
    
}

extension ProductDetailReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProducts(let products):
            newState.products = products
            newState.isLiked = products.checkLiked
            newState.likeCount = products.likeCount
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .toggleReceiptPopup(let isTap):
            newState.isReceiptTapped = isTap
            
        case .toggleLikeButton(let isLiked, let likeCount):
            newState.isLiked = isLiked
            newState.likeCount = likeCount
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
    
    private func fetchLikePost(productId: Int) -> Observable<Mutation> {
        return networkProvider.request(.likeProduct(productId: productId),
                                       decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                let newLikeStatus = !self.currentState.isLiked
                let newLikeCount = newLikeStatus ? self.currentState.likeCount + 1 : max(0, self.currentState.likeCount - 1)
                return .just(.toggleLikeButton(newLikeStatus, newLikeCount))
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
