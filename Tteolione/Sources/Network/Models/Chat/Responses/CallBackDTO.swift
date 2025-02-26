//
//  CallBackDTO.swift
//  Tteolione
//
//  Created by 전준영 on 2/14/25.
//

import Foundation

struct CallBackDTO: Decodable {
    
    let id: String
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
