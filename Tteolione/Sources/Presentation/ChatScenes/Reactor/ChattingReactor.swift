//
//  ChattingReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import Foundation
import ReactorKit
import RxSwift

enum RequestButtonState {
    case request       // 요청하기
    case approve       // 승인하기
    case pending       // 요청중..
    case rejectApprove // 승인하기 (비활성화)
    case complete // 승인하기 (비활성화)
    case review // 승인하기 (비활성화)
}

final class ChattingReactor: Reactor {
    
    enum Action {
        case socketConnect
        case sendMessage(String)
        case socketDisconnect
        case updateSendButtonState(String)
        case addMessages([ChatMessage])
        case fetchPutRequest(productId: Int, chatRoomId: Int)
        case fetchPutApprove(buyerId: Int, productId: Int, chatRoomId: Int)
        case fetchPutReject(buyerId: Int, productId: Int, chatRoomId: Int)
        case pushReviewView(productId: Int)
        case updateRequestButtonStatus(RequestButtonState)
    }
    
    enum Mutation {
        case setSocketConnected(Bool)
        case receiveMessage(String)
        case viewDisappeared(Bool)
        case showError(NetworkError)
        case addMessages([ChatMessage])
        case setSendButtonEnabled(Bool)
        case setProductData(ChatContentDTO?)
        case updateRequestButtonStatus(RequestButtonState)
        case pushReviewView(Bool)
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
        var productData: ChatContentDTO?
        var requestButtonState: RequestButtonState = .request
        var isReviewViewPushed: Bool = false
    }
    
    private var chatWebSocketService: ChatWebSocketService?
    private let networkChatProvider: NetworkProvider<ChatAPI>
    private let disposeBag = DisposeBag()
    private let dbManager = DBManager.shared
    var initialState = State()
    
    init(chatId: Int,
         productId: Int,
         networkChatProvider: NetworkProvider<ChatAPI>) {
        self.networkChatProvider = networkChatProvider
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceivedMessage(_:)),
                                               name: .didReceiveMessage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCallBackMessage(_:)),
                                               name: .didCallBackMessage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRequestMessage(_:)),
                                               name: .didReceiveRequestMessage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRejectMessage(_:)),
                                               name: .didReceiveRejectMessage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePendingRequestMessage(_:)),
                                               name: .didReceivePendingRequest,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceiveRejectMessage(_:)),
                                               name: .didReceiveRejectApprove,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceiveApproveMessage(_:)),
                                               name: .didReceiveApprove,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceiveApproveToReviewMessage(_:)),
                                               name: .didReceiveApproveToReview,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCompleteReview(_:)),
                                               name: .didCompleteReview,
                                               object: nil)
        self.initialState = State(chatId: chatId,
                                  productId: productId)
        Task { @MainActor in
            let messages = dbManager.fetchMessages(chatRoomID: chatId)
            
            let chatMessages = messages.map { message in
                ChatMessage(
                    text: message.content,
                    type: message.isMine ? .sent : .received,
                    timestamp: FormatterManager.shared.getChatTimeFormat(from: Int64(message.sendTime))
                )
            }
            self.action.onNext(.addMessages(chatMessages))
        }
    }
}

extension ChattingReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .socketConnect:
            return .concat([
                .just(.setSocketConnected(true)),
                fetchChatRoom(roomNo: currentState.chatId ?? 0)
            ])
            
        case .sendMessage(let message):
            chatWebSocketService?.sendMessage(content: message)
            let chatMessage = ChatMessage(text: message,
                                          type: .sent,
                                          timestamp: FormatterManager.shared.getChatTimeFormat())
            return .concat([
                .just(.addMessages([chatMessage])),
                .just(.setSendButtonEnabled(false))
            ])
            
        case .socketDisconnect:
            chatWebSocketService?.disconnect()
            return .concat([
                .just(.setSocketConnected(false)),
                leaveChatRoom(chatRoomId: currentState.chatId ?? 0)
            ])
            
        case .updateSendButtonState(let text):
            return .just(.setSendButtonEnabled(!text.isEmpty))
            
        case .addMessages(let messages):
            return .just(.addMessages(messages))
            
        case .fetchPutRequest(let productId, let chatRoomId):
            return fetchPutRequest(productId: productId,
                                   chatRoomId: chatRoomId)
            
        case .fetchPutApprove(let buyerId, let productId, let chatRoomId):
            return fetchPutApprove(buyerId: buyerId,
                                   productId: productId,
                                   chatRoomId: chatRoomId)
            
        case .fetchPutReject(let buyerId, let productId, let chatRoomId):
            return fetchPutReject(buyerId: buyerId,
                                  productId: productId,
                                  chatRoomId: chatRoomId)
        case .updateRequestButtonStatus(let status):
            return .just(.updateRequestButtonStatus(status))
            
        case .pushReviewView:
            return .concat([
                .just(.pushReviewView(true)),
                .just(.pushReviewView(false))
            ])
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
            
        case .setSendButtonEnabled(let isEnabled):
            newState.isSendButtonEnabled = isEnabled
            
        case .addMessages(let messages):
            newState.messages.append(contentsOf: messages)
            
        case .setProductData(let ChatContentDTO):
            newState.productData = ChatContentDTO
            
        case .updateRequestButtonStatus(let status):
            newState.requestButtonState = status
            
        case .pushReviewView(let isView):
            newState.isReviewViewPushed = isView
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
    
    private func fetchChatRoom(roomNo: Int) -> Observable<Mutation> {
        let lastMessageTime = dbManager.getLastMessageTime(chatRoomID: roomNo) ?? 0

        return networkChatProvider.request(.getChatHistory(roomNo: roomNo,
                                                           date: lastMessageTime),
                                           decodingType: ServerResponse<ChatContentDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let chatContentDTO):
                self.chatWebSocketService = ChatWebSocketService(chatId: self.currentState.chatId ?? 0,
                                                                 productId: self.currentState.productId ?? 0,
                                                                 isMine: chatContentDTO.checkSeller)
                let newMessages = chatContentDTO.chatList
                if !newMessages.isEmpty {
                    newMessages.forEach { message in
                        let chatMessageData = ChatMessageData(
                            chatRoomNo: message.chatRoomNo,
                            content: message.content,
                            senderNo: message.senderNo,
                            productNo: chatContentDTO.productId,
                            sendTime: message.sendDate,
                            isMine: message.mine
                        )
                        self.dbManager.addItem(chatMessageData)
                    }
                    
                    let chatMessages = newMessages.map { message in
                        ChatMessage(
                            text: message.content,
                            type: message.mine ? .sent : .received,
                            timestamp: FormatterManager.shared.getChatTimeFormat(from: Int64(message.sendDate))
                        )
                    }
                    return .concat([
                        .just(.setProductData(chatContentDTO)),
                        .just(.addMessages(chatMessages))
                    ])
                } else {
                    return .just(.setProductData(chatContentDTO))
                }
                
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchPutRequest(productId: Int,
                                 chatRoomId: Int) -> Observable<Mutation> {
        return networkChatProvider.request(.requestShare(productId: productId,
                                                         chatRoomId: chatRoomId),
                                           decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
//                    .just(.viewDisappeared(true)),
//                    .just(.viewDisappeared(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchPutApprove(buyerId: Int,
                                 productId: Int,
                                 chatRoomId: Int) -> Observable<Mutation> {
        let body = ShareRequestBody(buyerId: buyerId)
        return networkChatProvider.request(.approveShare(productId: productId,
                                                         chatRoomId: chatRoomId,
                                                         body: body),
                                           decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
//                    .just(.viewDisappeared(true)),
//                    .just(.viewDisappeared(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchPutReject(buyerId: Int,
                                productId: Int,
                                chatRoomId: Int) -> Observable<Mutation> {
        let body = ShareRequestBody(buyerId: buyerId)
        return networkChatProvider.request(.rejectShare(productId: productId,
                                                        chatRoomId: chatRoomId,
                                                        body: body),
                                           decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
//                    .just(.viewDisappeared(true)),
//                    .just(.viewDisappeared(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func callBackMessage(chatRoomNo: Int, contentType: String,
                                 content: String, senderName: String,
                                 senderNo: Int, productNo: Int,
                                 sendTime: Int, readCount: Int,
                                 senderLoginId: String) {
        let body = CallBackRequestBody(
            id: nil,
            chatRoomNo: chatRoomNo,
            contentType: contentType,
            content: content,
            senderName: senderName,
            senderNo: senderNo,
            productNo: productNo,
            sendTime: sendTime,
            readCount: readCount,
            senderLoginId: senderLoginId
        )

        networkChatProvider.request(.sendMessageWithCallback(body: body),
                                    decodingType: ServerResponse<CallBackDTO>.self)
        .asObservable()
        .subscribe { event in
            switch event {
            case .next(let response):
                switch handleResponse(response) {
                case .success(let data):
                    let chatMessage = ChatMessageData(chatRoomNo: data.chatRoomNo,
                                                      content: data.content,
                                                      senderNo: data.senderNo,
                                                      productNo: data.productNo,
                                                      sendTime: data.sendTime,
                                                      isMine: true)
                    self.dbManager.addItem(chatMessage)
                case .failure(let error):
                    print("❌ CallBack 실패: \(error.localizedDescription)")
                }
            case .error(let error):
                print("🚨 CallBack 네트워크 오류: \(error.localizedDescription)")
            case .completed:
                print("✅ CallBack 요청 완료")
            }
        }.disposed(by: disposeBag)
    }
    
}

extension ChattingReactor {
    @objc private func handleReceivedMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let content = userInfo["content"] as? String,
              let senderNo = userInfo["senderNo"] as? Int,
              let timestamp = userInfo["timestamp"] as? Int,
              let chatRoomId = userInfo["chatRoomNo"] as? Int,
              let productNo = userInfo["productNo"] as? Int else {
            return print("없어")
        }
        let isMine = senderNo == currentState.chatId
        let formattedTime = FormatterManager.shared.getChatTimeFormat(from: Int64(timestamp))
        let chatMessage = ChatMessageData(chatRoomNo: chatRoomId,
                                          content: content,
                                          senderNo: senderNo,
                                          productNo: productNo,
                                          sendTime: timestamp,
                                          isMine: isMine)
        dbManager.addItem(chatMessage)
        action.onNext(.addMessages([ChatMessage(text: content, type: isMine ? .sent : .received, timestamp: formattedTime)]))
    }
    
    @objc private func handleCallBackMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let chatRoomNo = userInfo["chatRoomNo"] as? Int,
              let contentType = userInfo["contentType"] as? String,
              let content = userInfo["content"] as? String,
              let senderName = userInfo["senderName"] as? String,
              let senderNo = userInfo["senderNo"] as? Int,
              let productNo = userInfo["productNo"] as? Int,
              let sendTime = userInfo["sendTime"] as? Int,
              let readCount = userInfo["readCount"] as? Int,
              let senderLoginId = userInfo["senderLoginId"] as? String else {
            return print("실패")
        }
        
        callBackMessage(chatRoomNo: chatRoomNo,
                        contentType: contentType,
                        content: content,
                        senderName: senderName,
                        senderNo: senderNo,
                        productNo: productNo,
                        sendTime: sendTime,
                        readCount: readCount,
                        senderLoginId: senderLoginId)
    }
    
    @objc private func handleRequestMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.approve))
    }
    
    @objc private func handleRejectMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.request))
    }
    
    @objc private func handlePendingRequestMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.pending))
    }
    
    @objc private func handleReceiveRejectMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.rejectApprove))
    }
    
    @objc private func handleReceiveApproveMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.complete))
    }
    
    @objc private func handleReceiveApproveToReviewMessage(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.review))
    }
    
    @objc private func handleCompleteReview(_ notification: Notification) {
        action.onNext(.updateRequestButtonStatus(.complete))
    }
}
