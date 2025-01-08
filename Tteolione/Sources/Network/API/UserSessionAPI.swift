//
//  UserSessionAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum UserSessionAPI {
    case login(body: LoginRequestBody)
    case logout
}

extension UserSessionAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/users/login"
            
        case .logout:
            return "/api/users/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .logout:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value]
            
        case .logout:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value,
                    Header.authorization.key: Header.authorization.value]
        }
    }
}
