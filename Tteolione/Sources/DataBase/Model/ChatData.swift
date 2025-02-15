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

    init(messageID: String = UUID().uuidString,
         chatRoomNo: Int,
         content: String,
         senderNo: Int,
         productNo: Int,
         sendTime: Int,
         isMine: Bool) {
        self.messageID = messageID
        self.chatRoomNo = chatRoomNo
        self.content = content
        self.senderNo = senderNo
        self.productNo = productNo
        self.sendTime = sendTime
        self.isMine = isMine
    }
}
