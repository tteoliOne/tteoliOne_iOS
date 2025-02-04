//
//  SideMenuReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/4/25.
//

import Foundation
import ReactorKit
import RxSwift

final class SideMenuReactor: Reactor {
    
    enum Action {
        case xButtonTap
        case fetchLikeLists
        case navigateToDetailView(Int)
    }
    
    enum Mutation {
        case setProducts(SavedProdcutDTO)
        case showError(NetworkError)
        case setXTapped(Bool)
        case setDetailView(Bool, Int?)
    }
    
    struct State {
        var products: [SavedProdcutDTO] = []
        var errorMessage: String?
        var navigateToPop: Bool = false
        var navigateToDetailView: Bool = false
        var productId: Int?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension SideMenuReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .xButtonTap:
            return .concat([
                .just(.setXTapped(true)),
                .just(.setXTapped(false))
            ])
            
        case .fetchLikeLists:
            return fetchLikeLists()
            
        case .navigateToDetailView(let productId):
            return .concat([
                .just(.setDetailView(true, productId)),
                .just(.setDetailView(false, nil))
            ])
        }
    }
    
}

extension SideMenuReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setProducts(let products):
            newState.products = [products]
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .setXTapped(let isPop):
            newState.navigateToPop = isPop
            
        case .setDetailView(let isNavigate, let productId):
            newState.navigateToDetailView = isNavigate
            newState.productId = productId
        }
        
        return newState
    }
    
}

extension SideMenuReactor {
    
    private func fetchLikeLists() -> Observable<Mutation> {
        return networkProvider.request(.likeMyProductList,
                                       decodingType: ServerResponse<SavedProdcutDTO>.self)
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
