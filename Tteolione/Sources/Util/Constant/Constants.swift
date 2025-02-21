//
//  Constants.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation

enum LoginTypeKey: String {
    case kakao
    case apple
    case local
}

struct MenuItem: Equatable {
    let title: String
}

enum PostViewType: String {
    case post
    case edit
}

enum ReportType: String {
    case products
    case chat
}

enum ReportCategory: String {
    case spam
    case imageViolence = "image-violence"
    case information
    case etc
}

enum StatusType: String {
    case eNew
    case eSoldOut
    case saved
}

enum ChatMessageType {
    case received
    case sent
    case notice
}

struct ChatMessage {
    let text: String
    let type: ChatMessageType
    let timestamp: String
    let opponentProfile: String?
    
    var isMine: Bool {
        return type == .sent
    }
}

enum AddressViewType: String {
    case login
    case change
}
