//
//  ChatListReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ChatListReactor: Reactor {
    
    enum Action {
        case fetchChatList
        case tableIndexTap(Int, Int)
    }
    
    enum Mutation {
        case setChatList([ChatListDTO])
        case showError(NetworkError)
        case tableIndexTapped(Bool)
        case setSelectedChatNo(Int?)
        case setSelectedProductNo(Int?)
    }
    
    struct State {
        var setChatListDTO: [ChatListDTO]?
        var errorMessage: String?
        var isTableIndexTapped: Bool = false
        var selectedChatNo: Int?
        var selectedProductNo: Int?
    }
    
    private let networkChatProvider: NetworkProvider<ChatAPI>
    let initialState = State()
    
    init(networkChatProvider: NetworkProvider<ChatAPI>) {
        self.networkChatProvider = networkChatProvider
    }
}

extension ChatListReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchChatList:
            return fetchChatList()
            
        case let .tableIndexTap(chatNo, productNo):
            return .concat([
                .just(.setSelectedChatNo(chatNo)),
                .just(.setSelectedProductNo(productNo)),
                .just(.tableIndexTapped(true)),
                .just(.tableIndexTapped(false))
            ])
        }
    }
    
}

extension ChatListReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setChatList(let dto):
            newState.setChatListDTO = dto
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .setSelectedChatNo(let chatNo):
            newState.selectedChatNo = chatNo
            
        case .tableIndexTapped(let isTap):
            newState.isTableIndexTapped = isTap
            
        case .setSelectedProductNo(let productNo):
            newState.selectedProductNo = productNo
        }
        
        return newState
    }
    
}

extension ChatListReactor {
    private func fetchChatList() -> Observable<Mutation> {
        return networkChatProvider.request(.getChatRoomList,
                                           decodingType: ServerResponse<[ChatListDTO]>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setChatList(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
