//
//  ChattingReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import Foundation
import ReactorKit
import RxSwift

enum ChatMessageType {
    case received
    case sent
}

struct ChatMessage {
    let text: String
    let type: ChatMessageType
    let timestamp: String
    
    var isMine: Bool {
        return type == .sent
    }
}


final class ChattingReactor: Reactor {
    
    enum Action {
        case socketConnect
        case sendMessage(String)
        case socketDisconnect
        case updateSendButtonState(String)
    }
    
    enum Mutation {
        case setSocketConnected(Bool)
        case receiveMessage(String)
        case viewDisappeared(Bool)
        case showError(NetworkError)
        case addMessage(ChatMessage)
        case setSendButtonEnabled(Bool)
    }
    
    struct State {
        var chatId: Int?
        var productId: Int?
        var isConnected: Bool = false
        var receivedMessages: [String] = []
        var isViewDisappeared: Bool = false
        var errorMessage: String?
        var messages: [ChatMessage] = []
        var isSendButtonEnabled: Bool = false
    }
    
    private var chatWebSocketService: ChatWebSocketService?
    private let networkChatProvider: NetworkProvider<ChatAPI>
    var initialState = State()
    
    init(chatId: Int,
         productId: Int,
         networkChatProvider: NetworkProvider<ChatAPI>) {
        self.networkChatProvider = networkChatProvider
        var state = State(chatId: chatId,
                          productId: productId)
           state.messages = [
               ChatMessage(text: "안녕하세요!ㄴㅇㅁㄹㄴㅇㄹㄴㅇㅁ란왼이ㅏㅓ\nㄹㄴ어ㅣ라ㅓㄴ이ㅏ러니아\nsdlfasjflksdj\nㅇ리머ㅏㄴㅇ", type: .received, timestamp: "오후 10:05"),
               ChatMessage(text: "반갑습니다 :)", type: .sent, timestamp: "오후 10:06")
           ]
           self.initialState = state
    }
}

extension ChattingReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .socketConnect:
            chatWebSocketService = ChatWebSocketService(chatId: currentState.chatId ?? 0,
                                                        productId: currentState.productId ?? 0)
            return .just(.setSocketConnected(true))
            
        case .sendMessage(let message):
            chatWebSocketService?.sendMessage(content: message)
            let message = ChatMessage(text: message, type: .sent, timestamp: "오후 10:10")
            return .just(.addMessage(message))
//            return .empty()
            
        case .socketDisconnect:
            chatWebSocketService?.disconnect()
            return .concat([
                .just(.setSocketConnected(false)),
                leaveChatRoom(chatRoomId: currentState.chatId ?? 0)
            ])
            
        case .updateSendButtonState(let text):
            return .just(.setSendButtonEnabled(!text.isEmpty))
        }
    }
}

extension ChattingReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSocketConnected(let isConnected):
            newState.isConnected = isConnected
            
        case .receiveMessage(let message):
            newState.receivedMessages.append(message)
            
        case .viewDisappeared(let isDisappeared):
            newState.isViewDisappeared = isDisappeared
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .addMessage(let message):
            newState.messages.append(message)
            
        case .setSendButtonEnabled(let isEnabled):
            newState.isSendButtonEnabled = isEnabled
        }
        
        return newState
    }
}

extension ChattingReactor {
    
    private func leaveChatRoom(chatRoomId: Int) -> Observable<Mutation> {
        return networkChatProvider.request(.leaveChatRoom(chatRoomId: chatRoomId),
                                            decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
                    .just(.viewDisappeared(true)),
                    .just(.viewDisappeared(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
