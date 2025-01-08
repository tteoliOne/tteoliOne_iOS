//
//  CallBackRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct CallBackRequestBody: Encodable {
    
    let id: String?
    let chatRoomNo: Int
    let contentType: String
    let content: String
    let senderName: String
    let senderNo: Int
    let productNo: Int
    let sendTime: Int
    let readCount: Int
    let senderLoginId: String
    
}
