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
        case nextButtonTap(Int)
        case toggleLike(Int)
    }
    
    enum Mutation {
        case setProducts(ProductDTO)
        case showError(NetworkError)
        case setNavigateToPost(Bool)
        case setProductId([Int])
        case updateProductLike(ProductDTO)
        case showToastMessage(String?)
        case setCategortId(Int?)
    }
    
    struct State {
        var products: [ProductDTO] = []
        var errorMessage: String?
        var navigateToPost: Bool = false
        var productIds: [Int] = []
        var showToastMessage: String?
        var categoryId: Int?
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
            
        case .toggleLike(let productId):
            return fetchLikePost(productId: productId)
            
        case .nextButtonTap(let id):
            guard currentState.categoryId != id else { return .empty() }
            return .concat([
                .just(.setCategortId(id)),
                .just(.setCategortId(nil))
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
            
//        case .setProcessingLike(let isProcessing):
//            newState.isProcessingLike = isProcessing
            
        case .setCategortId(let id):
            if newState.categoryId != id {
                newState.categoryId = id
            }
        case .updateProductLike(let updatedDTO):
            newState.products = [updatedDTO]
            
        case .showToastMessage(let message):
            newState.showToastMessage = message
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
            case .success(let success):
                guard let updatedProductDTO = self.currentState.products.first else {
                    print("❌ 데이터 없음")
                    return .empty()
                }

                var updatedList = updatedProductDTO.list

                for (listIndex, var productList) in updatedList.enumerated() {
                    if let productIndex = productList.products.firstIndex(where: { $0.productId == productId }) {
                        print("✅ 서버 반영 - listIndex: \(listIndex), productIndex: \(productIndex), productId: \(productId)")

                        productList.products[productIndex].toggleLike()
                        updatedList[listIndex] = productList
                    }
                }

                let updatedDTO = ProductDTO(list: updatedList)

                return .concat([
                    .just(.updateProductLike(updatedDTO)), // ✅ 최종 UI 업데이트
                    .just(.showToastMessage(success)),
                    .just(.showToastMessage(nil))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
