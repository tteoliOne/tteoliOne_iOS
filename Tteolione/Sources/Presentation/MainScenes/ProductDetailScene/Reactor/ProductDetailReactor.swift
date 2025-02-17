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
        case editPost
        case deletePost
        case reportPost
        case callButtonTap
        case profileTap
    }
    
    enum Mutation {
        case setProducts(ProductDetailDTO)
        case showError(NetworkError)
        case toggleReceiptPopup(Bool)
        case toggleLikeButton(Bool, Int)
        case showEditScreen(Bool)
        case deleteConfirmation(Bool)
        case showReportScreen(Bool)
        case callButtonTapped(Bool)
        case setChatDto(ChatDTO)
        case profileTapped(Bool)
        case setSellerId(Int)
    }

    struct State {
        var productId: Int = 0
        var sellerId: Int = 0
        var products: ProductDetailDTO?
        var errorMessage: String?
        var isReceiptTapped: Bool = false
        var isLiked: Bool = false
        var likeCount: Int = 0
        var isEditScreenShown: Bool = false
        var isDelete: Bool = false
        var isReportScreenShown: Bool = false
        var isCallButtonTapped: Bool = false
        var chatDto: ChatDTO?
        var isProfileTap: Bool = false
    }
    
    private let networkPorductProvider: NetworkProvider<ProductServiceAPI>
    private let networkChatProvider: NetworkProvider<ChatAPI>
    var initialState: State = State()
    
    init(networkPorductProvider: NetworkProvider<ProductServiceAPI>,
         networkChatProvider: NetworkProvider<ChatAPI>,
         productId: Int) {
        self.networkPorductProvider = networkPorductProvider
        self.networkChatProvider = networkChatProvider
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
            
        case .editPost:
            return .concat([
                .just(.showEditScreen(true)),
                .just(.showEditScreen(false))
            ])
            
        case .deletePost:
            return deletePost(productId: currentState.productId)
            
        case .reportPost:
            return .concat([
                .just(.showReportScreen(true)),
                .just(.showReportScreen(false))
            ])
            
        case .callButtonTap:
            return createChat(productId: currentState.productId)
            
        case .profileTap:
            return .concat([
                .just(.profileTapped(true)),
                .just(.profileTapped(false))
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
            newState.isLiked = products.checkLiked
            newState.likeCount = products.likeCount
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .toggleReceiptPopup(let isTap):
            newState.isReceiptTapped = isTap
            
        case .toggleLikeButton(let isLiked, let likeCount):
            newState.isLiked = isLiked
            newState.likeCount = likeCount
            
        case .showEditScreen(let isEdit):
            newState.isEditScreenShown = isEdit
            
        case .deleteConfirmation(let isDelete):
            newState.isDelete = isDelete
            
        case .showReportScreen(let isReport):
            newState.isReportScreenShown = isReport
            
        case .callButtonTapped(let isCall):
            newState.isCallButtonTapped = isCall
            
        case .setChatDto(let dto):
            newState.chatDto = dto
            
        case .profileTapped(let tapped):
            newState.isProfileTap = tapped
            
        case .setSellerId(let id):
            newState.sellerId = id
        }
        
        return newState
    }
    
}

extension ProductDetailReactor {
    
    private func fetchGetProduct(_ productId: Int) -> Observable<Mutation> {
        return networkPorductProvider.request(.getDetailProduct(productId: productId),
                                       decodingType: ServerResponse<ProductDetailDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setProducts(dto)),
                    .just(.setSellerId(dto.sellerId))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchLikePost(productId: Int) -> Observable<Mutation> {
        return networkPorductProvider.request(.likeProduct(productId: productId),
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
    
    private func deletePost(productId: Int) -> Observable<Mutation> {
        return networkPorductProvider.request(.deleteProduct(productId: productId),
                                       decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
                    .just(.deleteConfirmation(true)),
                    .just(.deleteConfirmation(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func createChat(productId: Int) -> Observable<Mutation> {
        let body = CreateChatRoomRequestBody(productNo: productId)
        return networkChatProvider.request(.createChatRoom(body: body),
                                           decodingType: ServerResponse<ChatDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setChatDto(dto)),
                    .just(.callButtonTapped(true)),
                    .just(.callButtonTapped(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
