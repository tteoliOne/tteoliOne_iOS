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
        case loadMore
        case backButtonTap
        case selectProduct(ProductPreviewDTO)
    }
    
    enum Mutation {
        case setProducts(ProductFilterListDTO)
        case appendProducts(ProductFilterListDTO)
        case setSelectedProduct(ProductPreviewDTO)
        case showDetailView(Bool)
        case showError(NetworkError)
        case isBackButtonTapped(Bool)
        case updatePageInfo(Int, Bool)
    }
    
    struct State {
        var status: StatusType?
        var setProductDTO: ProductFilterListDTO?
        var selectedProduct: ProductPreviewDTO?
        var isShowDetailView: Bool = false
        var errorMessage: String?
        var isBackButtonTapped: Bool = false
        var currentPage: Int = 0
        var isLastPage: Bool = false
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
                return fetchProductsPost(status: currentState.status ?? .eNew,
                                         page: 0)
                
            case .eSoldOut:
                return fetchProductsPost(status: currentState.status ?? .eSoldOut,
                                         page: 0)
                
            case .saved:
                return fetchSavedProductsPost(page: 0)
                
            default:
                return .empty()
            }
            
        case .backButtonTap:
            return .concat([
                .just(.isBackButtonTapped(true)),
                .just(.isBackButtonTapped(false))
            ])
            
        case .selectProduct(let product):
            return .concat([
                .just(.setSelectedProduct(product)),
                .just(.showDetailView(true)),
                .just(.showDetailView(false))
            ])
            
        case .loadMore:
            guard !currentState.isLastPage else { return .empty() }
            switch currentState.status {
            case .eNew:
                return fetchProductsPost(status: currentState.status ?? .eNew,
                                         page: currentState.currentPage + 1)
                
            case .eSoldOut:
                return fetchProductsPost(status: currentState.status ?? .eSoldOut,
                                         page: currentState.currentPage + 1)
                
            case .saved:
                return fetchSavedProductsPost(page: currentState.currentPage + 1)
                
            default:
                return .empty()
            }
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
            
        case .setSelectedProduct(let product):
            newState.selectedProduct = product
            
        case .showDetailView(let isShow):
            newState.isShowDetailView = isShow
            
        case .appendProducts(let dto):
            guard let existingDTO = newState.setProductDTO else { return newState }
            let newContent = existingDTO.content + dto.content
            newState.setProductDTO = ProductFilterListDTO(content: newContent,
                                                          pageable: dto.pageable,
                                                          size: dto.size,
                                                          number: dto.number,
                                                          sort: dto.sort,
                                                          numberOfElements: dto.numberOfElements,
                                                          first: dto.first,
                                                          last: dto.last,
                                                          empty: dto.empty)
        
        case .updatePageInfo(let page, let isLast):
            newState.currentPage = page
            newState.isLastPage = isLast
        }
        
        return newState
    }
    
}

extension MyProductListReactor {
    private func fetchProductsPost(status: StatusType,
                                   page: Int) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           page: page,
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
                    page == 0 ? .just(.setProducts(dto)) : .just(.appendProducts(dto)),
                    .just(.updatePageInfo(page, dto.last))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchSavedProductsPost(page: Int) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           page: page,
                                           size: 5,
                                           sort: "createAt-desc")
        return networkProvider.request(.myLikeProducts(query: query),
                                       decodingType: ServerResponse<ProductFilterListDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    page == 0 ? .just(.setProducts(dto)) : .just(.appendProducts(dto)),
                    .just(.updatePageInfo(page, dto.last))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
