//
//  ChatData.swift
//  Tteolione
//
//  Created by 전준영 on 2/12/25.
//

import Foundation
import SwiftData

@Model
final class ChatMessageData {
    @Attribute(.unique) var messageID: String
    var chatRoomNo: Int
    var content: String
    var senderNo: Int
    var productNo: Int
    var sendTime: Int
    var isMine: Bool
    var contentType: String
    var unRead: Bool?
    var opponentProfileURL: String?
    var localProfilePath: String?

    init(messageID: String = UUID().uuidString,
         chatRoomNo: Int,
         content: String,
         senderNo: Int,
         productNo: Int,
         sendTime: Int,
         isMine: Bool,
         contentType: String,
         unRead: Bool? = false,
         opponentProfileURL: String? = nil,
         localProfilePath: String? = nil) {
        self.messageID = messageID
        self.chatRoomNo = chatRoomNo
        self.content = content
        self.senderNo = senderNo
        self.productNo = productNo
        self.sendTime = sendTime
        self.isMine = isMine
        self.contentType = contentType
        self.unRead = unRead
        self.opponentProfileURL = opponentProfileURL
        self.localProfilePath = localProfilePath
    }
}
