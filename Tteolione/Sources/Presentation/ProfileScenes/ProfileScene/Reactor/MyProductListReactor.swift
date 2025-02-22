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
        case toggleLike(Int)
    }
    
    enum Mutation {
        case setProducts(ProductFilterListDTO)
        case appendProducts(ProductFilterListDTO)
        case setSelectedProduct(ProductPreviewDTO)
        case showDetailView(Bool)
        case showError(NetworkError)
        case isBackButtonTapped(Bool)
        case updatePageInfo(Int, Bool)
        case updateProductLike(ProductFilterListDTO)
        case showToastMessage(String?)
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
        var showToastMessage: String?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    private let productNetworkProvider: NetworkProvider<ProductServiceAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>,
         productNetworkProvider: NetworkProvider<ProductServiceAPI>,
         status: StatusType) {
        self.networkProvider = networkProvider
        self.productNetworkProvider = productNetworkProvider
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
            
        case .toggleLike(let productId):
            return fetchLikePost(productId: productId)
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
            
        case .updateProductLike(let updatedDTO):
            newState.setProductDTO = updatedDTO
            
        case .showToastMessage(let message):
            newState.showToastMessage = message
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
    
    private func fetchLikePost(productId: Int) -> Observable<Mutation> {
        return productNetworkProvider.request(.likeProduct(productId: productId),
                                              decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let success):
                
                guard let productList = self.currentState.setProductDTO else {
                    print("❌ 데이터 없음")
                    return .empty()
                }

                var updatedProducts = productList.content

                if let index = updatedProducts.firstIndex(where: { $0.productId == productId }) {
                    print("✅ 변경할 상품 찾음 - index: \(index), productId: \(productId)")
                    updatedProducts[index].liked.toggle()
                    updatedProducts[index].totalLikes += updatedProducts[index].liked ? 1 : -1
                } else {
                    print("❌ 해당 productId를 찾을 수 없음: \(productId)")
                }

                let updatedDTO = ProductFilterListDTO(
                    content: updatedProducts,
                    pageable: productList.pageable,
                    size: productList.size,
                    number: productList.number,
                    sort: productList.sort,
                    numberOfElements: productList.numberOfElements,
                    first: productList.first,
                    last: productList.last,
                    empty: productList.empty
                )
                
                return .concat([
                    .just(.updateProductLike(updatedDTO)),
                    .just(.showToastMessage(success)),
                    .just(.showToastMessage(nil))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
