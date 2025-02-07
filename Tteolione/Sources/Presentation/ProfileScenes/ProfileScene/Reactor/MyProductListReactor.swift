//
//  MyProductListReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MyProductListReactor: Reactor {
    
    enum Action {
        case fetchList
        case backButtonTap
    }
    
    enum Mutation {
        case setProducts(ProductFilterListDTO)
        case showError(NetworkError)
        case isBackButtonTapped(Bool)
    }
    
    struct State {
        var status: StatusType?
        var setProductDTO: ProductFilterListDTO?
        var errorMessage: String?
        var isBackButtonTapped: Bool = false
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>,
         status: StatusType) {
        self.networkProvider = networkProvider
        self.initialState = State(status: status)
    }
    
}

extension MyProductListReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchList:
            switch currentState.status {
            case .eNew:
                return fetchProductsPost(status: currentState.status ?? .eNew)
                
            case .eSoldOut:
                return fetchProductsPost(status: currentState.status ?? .eSoldOut)
                
            case .saved:
                return fetchSavedProductsPost()
                
            default:
                return .empty()
            }
            
        case .backButtonTap:
            return .concat([
                .just(.isBackButtonTapped(true)),
                .just(.isBackButtonTapped(false))
            ])
        }
    }
    
}

extension MyProductListReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProducts(let dto):
            newState.setProductDTO = dto
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .isBackButtonTapped(let isBack):
            newState.isBackButtonTapped = isBack
        }
        
        return newState
    }
    
}

extension MyProductListReactor {
    private func fetchProductsPost(status: StatusType) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           page: 0,
                                           size: 5,
                                           sort: "createAt-desc",
                                           status: status.rawValue)
        return networkProvider.request(.myShareProducts(query: query),
                                       decodingType: ServerResponse<ProductFilterListDTO>.self)
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
    
    private func fetchSavedProductsPost() -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           page: 0,
                                           size: 5,
                                           sort: "createAt-desc")
        return networkProvider.request(.myLikeProducts(query: query),
                                       decodingType: ServerResponse<ProductFilterListDTO>.self)
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
