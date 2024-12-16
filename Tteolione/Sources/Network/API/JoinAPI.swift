//
//  JoinAPI.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation
import Moya

enum JoinAPI {
    case joinEmail(body: JoinRequestBody)
    case validateEmail(body: JoinRequestBody)
    case validateID(body: JoinRequestBody)
    case validateNickname(body: JoinRequestBody)
    case signUp(body: SignUpProfileImageRequestBody)
}

extension JoinAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .joinEmail:
            return "/api/v2/email/send"
            
        case .validateEmail:
            return "/api/v2/email/verify"
            
        case .validateID:
            return "/api/users/check/login-id"
            
        case .validateNickname:
            return "/api/users/check/nickname"
            
        case .signUp:
            return "/api/users/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .joinEmail, .validateEmail,
             .validateID, .validateNickname,
             .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .joinEmail(body),
            let .validateEmail(body),
            let .validateID(body),
            let .validateNickname(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .signUp(body):
            return .uploadMultipart(body.toMultipartFormData())
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .joinEmail,
                .validateEmail,
                .validateID,
                .validateNickname:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value]
        case .signUp:
            return [Header.contentTypeJson.key: Header.contentTypeMulti.value]
        }
    }
}
