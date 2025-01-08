//
//  ChatContentDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ChatContentDTO: Decodable {
    
    let loginId: String
    let productId: Int
    let title: String
    let productImage: String
    let sharePrice: Int
    let opponentId: Int
    let opponentNickname: String
    let opponentProfile: String
    let exitOpponent: Bool
    let soldStatus: String
    let checkSeller: Bool
    let checkReservation: Bool
    let checkReview: Bool
    let chatList: [ChatContentListDTO]
    
}

struct ChatContentListDTO: Decodable {
    
    let id: String
    let chatRoomNo: Int
    let senderNo: Int
    let senderName: String
    let contentType: String
    let content: String
    let sendDate: Int
    let readCount: Int
    let mine: Bool
    
}
