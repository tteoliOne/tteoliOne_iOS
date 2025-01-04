//
//  FindAccountAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import Foundation
import Moya

enum FindAccountAPI {
    case findID(body: FindAccountRequestBody)
    case validateIdEmail(body: FindAccountRequestBody)
    case findPassword(body: FindAccountRequestBody)
    case validatePasswordEmail(body: FindAccountRequestBody)
    case resetPassword(body: FindAccountRequestBody)
}

extension FindAccountAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .findID:
            return "/api/users/find/login-id"
            
        case .validateIdEmail:
            return "/api/users/verify/login-id"
            
        case .findPassword:
            return "/api/users/find/password"
            
        case .validatePasswordEmail:
            return "/api/users/verify/password"
            
        case .resetPassword:
            return "/api/users/reset/password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .findID, .validateIdEmail,
             .findPassword, .validatePasswordEmail:
            return .post
            
        case .resetPassword:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .findID(let body),
             .validateIdEmail(let body),
             .findPassword(let body),
             .validatePasswordEmail(let body),
             .resetPassword(let body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .findID,
             .validateIdEmail,
             .findPassword,
             .validatePasswordEmail,
             .resetPassword:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value]
        }
    }
}
