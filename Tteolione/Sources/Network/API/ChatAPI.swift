//
//  ChatAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum ChatAPI {
    case createChatRoom(body: CreateChatRoomRequestBody)
    case getChatRoomList
    case getChatHistory(roomNo: Int)
    case sendMessageWithCallback(body: CallBackRequestBody)
    case leaveChatRoom(chatRoomId: Int)
    case deleteChatRoom(chatRoomId: Int)
    case requestShare(productId: Int,
                      chatRoomId: Int)
    case approveShare(productId: Int,
                      chatRoomId: Int,
                      body: ShareRequestBody)
    case rejectShare(productId: Int,
                     body: ShareRequestBody)
    case submitShareReview(productId: Int,
                           body: SubmitReviewRequestBody)
}


extension ChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createChatRoom:
            return "/api/chatRoom"
            
        case .getChatRoomList:
            return "/api/chatRoom"
            
        case let .getChatHistory(roomNo):
            return "/api/chatRoom/\(roomNo)"
            
        case .sendMessageWithCallback:
            return "/api/chatRoom/notification"
            
        case let .leaveChatRoom(chatRoomId):
            return "/api/chatRoom/\(chatRoomId)"
            
        case let .deleteChatRoom(chatRoomId):
            return "/api/chatRoom/\(chatRoomId)"
            
        case let .requestShare(productId, chatRoomId):
            return "/api/products/\(productId)/chatRoom/\(chatRoomId)/request"
            
        case let .approveShare(productId, chatRoomId, _):
            return "/api/products/\(productId)/chatRoom/\(chatRoomId)/approve"
            
        case let .rejectShare(productId, _):
            return "/api/products/\(productId)/reject"
            
        case let .submitShareReview(productId, _):
            return "/api/products/\(productId)/review"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getChatRoomList, .getChatHistory:
            return .get
            
        case .createChatRoom, .sendMessageWithCallback,
                .submitShareReview:
            return .post
            
        case .leaveChatRoom, .requestShare,
                .approveShare, .rejectShare:
            return .put
            
        case .deleteChatRoom:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .createChatRoom(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .sendMessageWithCallback(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .approveShare(_, _, body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .rejectShare(_, body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .submitShareReview(_, body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case .getChatHistory, .leaveChatRoom,
                .deleteChatRoom, .requestShare,
                .getChatRoomList:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [Header.contentTypeJson.key: Header.contentTypeJson.value,
                Header.authorization.key: Header.authorization.value]
    }
}
