//
//  JoinAPI.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation
import Moya

enum JoinAPI {
    case joinEmail(email: String)
}

extension JoinAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .joinEmail:
            return "/api/v2/email/send"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .joinEmail:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .joinEmail(email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
