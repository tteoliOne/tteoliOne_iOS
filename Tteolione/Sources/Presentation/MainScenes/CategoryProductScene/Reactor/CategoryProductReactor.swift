//
//  CategoryProductReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import Foundation
import ReactorKit
import RxSwift

final class CategoryProductReactor: Reactor {
    
    enum Action {
        case fetchProduct
        case loadMore
        case selectProduct(ProductPreviewDTO)
        case toggleSortOrder
        case toggleLike(Int)
    }
    
    enum Mutation {
        case setProducts(ProductFilterListDTO)
        case appendProducts(ProductFilterListDTO)
        case setSelectedProduct(ProductPreviewDTO)
        case showDetailView(Bool)
        case showError(NetworkError)
        case updatePageInfo(Int, Bool)
        case setSortOrder(String)
        case updateProductLike(ProductFilterListDTO)
        case showToastMessage(String?)
    }
    
    struct State {
        var categoryId: Int?
        var product: ProductFilterListDTO?
        var selectedProduct: ProductPreviewDTO?
        var isShowDetailView: Bool = false
        var errorMessage: String?
        var currentPage: Int = 0
        var isLastPage: Bool = false
        var sortOrder: String = "createAt-desc"
        var showToastMessage: String?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>,
         categoryId: Int) {
        self.networkProvider = networkProvider
        self.initialState = State(categoryId: categoryId)
    }
    
}

extension CategoryProductReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProduct:
            return fetchProductsPost(categoryId: currentState.categoryId ?? 0,
                                     page: 0,
                                     sort: currentState.sortOrder)
            
        case .loadMore:
            guard !currentState.isLastPage else { return .empty() }
            return fetchProductsPost(categoryId: currentState.categoryId ?? 0,
                                     page: currentState.currentPage + 1,
                                     sort: currentState.sortOrder)
            
        case .selectProduct(let product):
            return .concat([
                .just(.setSelectedProduct(product)),
                .just(.showDetailView(true)),
                .just(.showDetailView(false))
            ])
            
        case .toggleSortOrder:
            let newSortOrder = currentState.sortOrder == "createAt-desc" ? "createAt-asc" : "createAt-desc"
            return .concat([
                .just(.setSortOrder(newSortOrder)),
                fetchProductsPost(categoryId: currentState.categoryId ?? 0,
                                  page: 0,
                                  sort: newSortOrder)
            ])
            
        case .toggleLike(let productId):
            return fetchLikePost(productId: productId)
        }
    }
    
}

extension CategoryProductReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setProducts(let dto):
            newState.product = dto
            
        case .appendProducts(let dto):
            guard let existingDTO = newState.product else { return state }
            let newContent = existingDTO.content + dto.content
            newState.product = ProductFilterListDTO(content: newContent,
                                                    pageable: dto.pageable,
                                                    size: dto.size,
                                                    number: dto.number,
                                                    sort: dto.sort,
                                                    numberOfElements: dto.numberOfElements,
                                                    first: dto.first,
                                                    last: dto.last,
                                                    empty: dto.empty)
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .updatePageInfo(let page, let isLast):
            newState.currentPage = page
            newState.isLastPage = isLast
            
        case .setSelectedProduct(let product):
            newState.selectedProduct = product
            
        case .showDetailView(let isShow):
            newState.isShowDetailView = isShow
            
        case .setSortOrder(let sortOrder):
            newState.sortOrder = sortOrder
            
        case .updateProductLike(let updatedDTO):
            newState.product = updatedDTO
            
        case .showToastMessage(let message):
            newState.showToastMessage = message
        }
        
        return newState
    }
    
}

extension CategoryProductReactor {
    private func fetchProductsPost(categoryId: Int,
                                   page: Int,
                                   sort: String) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           categoryId: categoryId,
                                           page: page,
                                           size: 5,
                                           sort: sort)
        return networkProvider.request(.getListSpecificProductList(query: query),
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
        return networkProvider.request(.likeProduct(productId: productId),
                                              decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let success):
                guard let productList = self.currentState.product else {
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
