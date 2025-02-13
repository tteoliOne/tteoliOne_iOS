//
//  ChatListDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ChatListDTO: Equatable, Decodable {
    
    let chatNo: Int
    let createMember: Int
    let joinMember: Int
    let productNo: Int
    let productTitle: String
    let regDate: Int
    let participant: ParticipantDTO
    let latestMessage: LastestMessageDTO?
    let unReadCount: Int
    
}

struct ParticipantDTO: Equatable, Decodable {
    
    let username: String
    let profile: String
    
}

struct LastestMessageDTO: Equatable, Decodable {
    
    let context: String
    let sendAt: Int
    
}
