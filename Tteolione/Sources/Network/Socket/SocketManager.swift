//
//  SocketManager.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import Foundation
import SwiftStomp

struct MessageData: Codable {
    let productNo: Int
    let chatRoomNo: Int
    let senderNo: Int
    let contentType: String
    let content: String
}

final class ChatWebSocketService: SwiftStompDelegate {
    
    private static var existingInstance: ChatWebSocketService?
    private var swiftStomp: SwiftStomp?
    private var hostURL: URL?
    
    var chatId: Int?
    var productId: Int?
    var userId: Int? {
        return UserDefaultsStorage.userID
    }
    var accessToken: String? {
        return UserDefaultsStorage.token
    }
    
    init(chatId: Int, productId: Int) {
        if let existingInstance = ChatWebSocketService.existingInstance {
            self.swiftStomp = existingInstance.swiftStomp
            self.chatId = existingInstance.chatId
            self.productId = existingInstance.productId
            return
        }
        
        self.chatId = chatId
        self.productId = productId
        self.hostURL = URL(string: APIURL.socketBaseURL)!
        ChatWebSocketService.existingInstance = self
        
        configure()
    }
    
    private func configure() {
        guard let chatId = chatId, let token = accessToken, let hostURL = hostURL else {
            print("🚨 chatId 또는 Token 없음!")
            return
        }
        
        let headers: [String: String] = [
            "Authorization": "\(token)",
            "chatRoomNo": "\(chatId)",
            "heart-beat": "10000,50000",
            "destination": "/pub/message",
        ]
        
        if swiftStomp == nil {
            swiftStomp = SwiftStomp(host: hostURL, headers: headers, httpConnectionHeaders: headers)
        }
        
        swiftStomp?.delegate = self
        swiftStomp?.autoReconnect = true
        swiftStomp?.connect(timeout: 5.0, acceptVersion: "1.1,1.2")
        
        enableAutoPing()
    }


    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("✅ WebSocket & STOMP 연결 성공!")
        guard let token = accessToken else {
            print("🚨 Token 없음!")
            return
        }
        let subscriptionPath = "/sub/pub/\(self.chatId ?? 0)"
        print("🔄 STOMP 구독 시도: \(subscriptionPath)")
        
        let headers: [String: String] = [
            "Authorization": "\(token)",
            "heart-beat": "10000,50000",
            "destination": "/pub/message",
        ]
        
        self.swiftStomp?.subscribe(to: subscriptionPath, mode: .clientIndividual, headers: headers)

        switch self.swiftStomp?.connectionStatus {
        case .connecting:
            print("Connecting to the server...")
        case .socketConnected:
            print("Scoket is connected but STOMP as sub-protocol is not connected yet.")
        case .fullyConnected:
            print("Both socket and STOMP is connected. Ready for messaging...")
        case .socketDisconnected:
            print("Socket is disconnected")
        case .none:
            print("noting")
        }
    }

    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("🚨 STOMP 오류 발생: \(briefDescription)")
        if let fullDescription = fullDescription {
            print("❌ 상세 오류: \(fullDescription)")
        }
        if let receiptId = receiptId {
            print("📌 관련된 receipt ID: \(receiptId)")
        }
        print("오류 타입: \(type)")
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("❌ WebSocket 연결 종료됨!")
    }
    
    func sendMessage(content: String, retryCount: Int = 5) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("🚨 메시지가 비어있음, 전송 취소됨")
            return
        }
        
        guard let chatId = chatId, chatId != 0 else {
            print("🚨 chatId가 설정되지 않음!")
            return
        }
        
        guard let productId = productId, productId != 0 else {
            print("🚨 productId가 설정되지 않음!")
            return
        }
        
        guard let token = accessToken else {
            print("🚨 토큰이 없음!")
            return
        }
        
        // ✅ **STOMP 연결 상태 확인**
        guard let stomp = swiftStomp else {
            print("🚨 [에러] SwiftStomp 인스턴스가 nil!")
            return
        }
        
        switch stomp.connectionStatus {
        case .fullyConnected:
            print("✅ STOMP 연결 상태: fullyConnected (메시지 전송 가능)")
        case .socketConnected, .connecting:
            if retryCount > 0 {
                print("⏳ STOMP 연결 대기 중... \(retryCount)회 남음")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.sendMessage(content: content, retryCount: retryCount - 1)
                }
            } else {
                print("🚨 [에러] STOMP 연결 실패: 메시지 전송 취소됨")
            }
            return
        case .socketDisconnected:
            print("🚨 [에러] WebSocket이 끊어져 있음! 메시지 전송 취소됨")
            return
        }

        let messageData: [String: Any] = [
            "productNo": productId,
            "chatRoomNo": chatId,
            "senderNo": userId ?? 0,
            "contentType": "chat",
            "content": content
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageData)
            guard let messageString = String(data: jsonData, encoding: .utf8) else {
                print("❌ 메시지 변환 실패: Encoding 오류")
                return
            }
            
            let contentLength = messageString.utf8.count
            
            let connectionHeaders = [
                "Authorization": "\(token)",
                "chatRoomNo": "\(chatId)",
                "content-length": "\(contentLength)",
                "destination": "/pub/message",
                "content-type": "application/json"
            ]
            
            print("📤 [디버깅] SwiftStomp.send() 호출 직전")
            print("📤 메시지 전송: \(messageString)")
            print("📤 content-length: \(contentLength)")
            print("📤 헤더: \(connectionHeaders)")

            // ✅ **전송 전에 STOMP 인스턴스 주소 확인**
            print("🧐 현재 메시지를 보내는 `swiftStomp` 인스턴스 주소: \(Unmanaged.passUnretained(stomp).toOpaque())")

            stomp.send(
                body: messageString,
                to: "/pub/message",
                receiptId: "send-\(UUID().uuidString)", // ✅ **서버에서 수신 확인을 위한 고유 ID 추가**
                headers: connectionHeaders
            )
            
            print("📤 [디버깅] SwiftStomp.send() 호출 완료")
            
        } catch {
            print("❌ 메시지 변환 실패: \(error)")
        }
    }


    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("✅ 메시지 전송 확인됨 (서버에서 확인됨), receipt ID: \(receiptId)")
    }

    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        print("📥 메시지 수신 확인됨! \n - messageId: \(messageId) \n - destination: \(destination) \n - message: \(message ?? "nil")")
        print("🧐 현재 메시지를 받는 `swiftStomp` 인스턴스 주소: \(Unmanaged.passUnretained(swiftStomp).toOpaque())")
    }
    
    func disconnect() {
        swiftStomp?.disconnect(force: true)
    }
    
    func enableAutoPing() {
        swiftStomp?.enableAutoPing(pingInterval: 30)
    }
}
