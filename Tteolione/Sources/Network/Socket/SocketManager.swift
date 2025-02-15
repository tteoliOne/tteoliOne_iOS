//
//  SocketManager.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import Foundation
import StompClientLib

struct MessageData: Codable {
    let productNo: Int
    let chatRoomNo: Int
    let senderNo: Int
    let contentType: String
    let content: String
}

final class ChatWebSocketService {
    
    private let networkChatProvider = NetworkProvider<ChatAPI>()
    private var socketClient = StompClientLib()
    private var hostURL: NSURL?
    private var isSubscribed = false
    private var pingTimer: Timer?
    
    var chatId: Int?
    var productId: Int?
    var topic: String {
        if let chatId = chatId {
            return "/sub/pub/\(chatId)"
        } else {
            return "/sub/pub/0"
        }
    }
    var userId: Int? {
        return UserDefaultsStorage.userID
    }
    var accessToken: String? {
        return UserDefaultsStorage.token
    }
    
    init(chatId: Int, productId: Int) {
        print("???")
        self.chatId = chatId
        self.productId = productId
        self.hostURL = NSURL(string: APIURL.socketBaseURL)
        configure()
    }
    
    /// STOMP WebSocket 설정
    private func configure() {
        guard let chatId = chatId, let token = accessToken, let hostURL = hostURL else {
            print("🚨 chatId 또는 Token 없음!")
            return
        }
        
        let connectionHeaders = [
            "Authorization": "\(token)",
            "chatRoomNo" : "\(chatId)",
            "heart-beat": "10000,50000"
        ]
        
        print("🔌 WebSocket 연결 시도 중...")
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: hostURL as URL),
                                              delegate: self, connectionHeaders: connectionHeaders)
        enableAutoPing()
    }
    
    /// STOMP 메시지 전송 (receipt 포함)
    func sendMessage(content: String) {
        guard let chatId = chatId, let userId = userId, let token = accessToken else {
            print("❌ 메시지 전송 불가: 필요한 정보 부족")
            return
        }
        
        let messageData: [String: Any] = [
            "productNo": productId ?? 0,
            "chatRoomNo": chatId,
            "senderNo": userId,
            "contentType": "chat",
            "content": content,
            "destination": "/pub/message"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageData)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                print("❌ JSON 변환 실패")
                return
            }
            
            let connectionHeaders: [String: String] = [
                "Authorization": "\(token)",
                "chatRoomNo": "\(chatId)",
                "heart-beat": "10000,50000",
                "content-type": "application/json"
            ]
            
            print("📤 메시지 전송 시도: \(messageData)")
            socketClient.sendMessage(
                message: jsonString,
                toDestination: "/pub/message",
                withHeaders: connectionHeaders,
                withReceipt: nil
            )
            
        } catch {
            print("❌ JSON 직렬화 실패: \(error)")
        }
    }
    
    /// WebSocket 연결 해제
    func disconnect() {
        print("🔌 WebSocket 연결 해제 요청됨")
        pingTimer?.invalidate()
        pingTimer = nil
        socketClient.disconnect()
        socketClient = StompClientLib()
        isSubscribed = false
    }
    
    /// 자동 Ping 유지 (30초 간격)
    func enableAutoPing() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self,
                  let token = self.accessToken,
                  let chatId = self.chatId else {
                print("🚨 Ping 전송 실패: 필요한 정보 없음")
                return
            }
            
            let pingHeaders: [String: String] = [
                "Authorization": "\(token)",
                "chatRoomNo": "\(chatId)",
                "heart-beat": "10000,50000",
                "content-type": "application/json"
            ]
            
            let pingMessage = "{}"
            
            print("🔄 Ping Sent to Server with Headers: \(pingHeaders)")
            
            self.socketClient.sendMessage(
                message: pingMessage,
                toDestination: "/pub/ping",
                withHeaders: pingHeaders,
                withReceipt: nil
            )
        }
    }
    
}

// MARK: - StompClientLibDelegate 구현
extension ChatWebSocketService: StompClientLibDelegate {
    func stompClient(client: StompClientLib!,
                     didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                     akaStringBody stringBody: String?,
                     withHeader header: [String : String]?,
                     withDestination destination: String) {
        print("📩 메시지 수신: \(String(describing: jsonBody)), destination: \(destination), header: \(String(describing: header))")
        
        guard let data = jsonBody as? [String: Any],
              let content = data["content"] as? String,
              let senderNo = data["senderNo"] as? Int,
              let timestamp = data["sendTime"] as? Int,
              let contentType = data["contentType"] as? String,
              let chatRoomNo = data["chatRoomNo"] as? Int,
              let senderName = data["senderName"] as? String,
              let readCount = data["readCount"] as? Int,
              let productNo = data["productNo"] as? Int,
              let senderLoginId = data["senderLoginId"] as? String else {
            print("❌ 메시지 파싱 실패")
            return
        }
        
        if senderNo != userId, contentType == "chat" {
            NotificationCenter.default.post(name: .didReceiveMessage,
                                            object: nil,
                                            userInfo: [
                                                "content": content,
                                                "senderNo": senderNo,
                                                "timestamp": timestamp,
                                                "chatRoomNo": chatRoomNo,
                                                "productNo": productNo
                                            ])
        } else if senderNo == userId, contentType == "chat" {
            NotificationCenter.default.post(name: .didCallBackMessage,
                                            object: nil,
                                            userInfo: [
                                                "chatRoomNo": chatRoomNo,
                                                "contentType": contentType,
                                                "content": content,
                                                "senderName": senderName,
                                                "senderNo": senderNo,
                                                "sendTime": timestamp,
                                                "readCount": readCount,
                                                "productNo": productNo,
                                                "senderLoginId": senderLoginId
                                            ])
        }
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("🚨 STOMP 오류 발생: \(description)")
    }
    
    /// STOMP 연결 성공 시 실행
    func stompClientDidConnect(client: StompClientLib!) {
        print("✅ WebSocket & STOMP 연결 성공!")
        
        guard let chatId = chatId, let token = accessToken else {
            print("⚠️ 토큰 없음!")
            return
        }
        print("🔄 STOMP 구독 시도: \(topic)")
        
        let authHeader = ["Authorization": "\(token)",
                          "chatRoomNo": "\(chatId)",
                          "heart-beat": "10000,50000",
                          "content-type": "application/json",
                          "id": "sub-\(chatId)"]
        socketClient.subscribeWithHeader(destination: topic,
                                         withHeader: authHeader)
        isSubscribed = true
    }
    
    /// STOMP 연결 종료 시 실행 (자동 재연결 추가)
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("❌ WebSocket 연결 종료됨!")
        isSubscribed = false
    }
    
    /// STOMP 메시지 수신
    func stompClientDidReceiveMessage(client: StompClientLib!, jsonBody: AnyObject?, withHeader header: [String : String]?, fromDestination destination: String) {
        print("📩 메시지 수신: \(String(describing: jsonBody ?? nil))")
    }
    
    /// STOMP 오류 발생 시 실행
    func stompClientDidReceiveError(client: StompClientLib!, description: String, message: Any?) {
        print("🚨 STOMP 오류 발생: \(description)")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("✅ 메시지 전송 확인됨, receipt ID: \(receiptId)")
    }
    
    func serverDidSendPing() {
        print("🔄 서버 Ping 수신")
    }
}
