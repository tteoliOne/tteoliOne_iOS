//
//  ChatDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ChatDTO: Equatable, Decodable {
    
    let chatId: Int
    let createMember: Int
    let joinMember: Int
    let productNo: Int
    let regDate: String
    
}
