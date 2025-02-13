//
//  ChatData.swift
//  Tteolione
//
//  Created by 전준영 on 2/12/25.
//

import Foundation
import SwiftData

enum MessageStatus: String, Codable {
    case pending   // 전송 중
    case sent      // 전송 완료
    case failed    // 전송 실패
}

@Model
final class ChatMessageData {
    @Attribute(.unique) var messageID: String
    var text: String
    var timestamp: Date
    var senderID: String
    var chatRoomID: String
    var status: MessageStatus
    var isRead: Bool

    init(messageID: String = UUID().uuidString,
         text: String,
         timestamp: Date,
         senderID: String,
         chatRoomID: String,
         status: MessageStatus = .pending,
         isRead: Bool = false) {
        self.messageID = messageID
        self.text = text
        self.timestamp = timestamp
        self.senderID = senderID
        self.chatRoomID = chatRoomID
        self.status = status
        self.isRead = isRead
    }
}
