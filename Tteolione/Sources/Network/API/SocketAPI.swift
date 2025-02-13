//
//  SocketAPI.swift
//  Tteolione
//
//  Created by 전준영 on 2/9/25.
//

import Foundation
import Moya

enum SocketAPI {
    case createChatRoom(chatId: Int)
}


extension SocketAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.socketBaseURL)!
    }
    
    var path: String {
        switch self {
        case .createChatRoom:
            return "/ws-stomp/websocket"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createChatRoom:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createChatRoom:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createChatRoom(let id):
            return [Header.contentTypeJson.key: Header.contentTypeJson.value,
                    Header.authorization.key: Header.authorization.value,
                    "chatId": "\(id)",
                    "heart-beat": "0,50000"]
        }
    }
}
