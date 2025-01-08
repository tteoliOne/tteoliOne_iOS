//
//  TokenAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum TokenAPI {
    case reissueToken(body: ReissueTokenRequestBody)
}

extension TokenAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .reissueToken:
            return "/api/users/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reissueToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .reissueToken(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .reissueToken:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value]
        }
    }
}
