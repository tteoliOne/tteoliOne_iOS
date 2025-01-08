//
//  SocialAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum SocialAPI {
    case kakaoLogin(body: SocialRequestBody)
    case kakaoProfile(body: SocialProfileImageRequestBody)
    case appleLogin(body: SocialRequestBody)
    case appleProfile(body: SocialProfileImageRequestBody)
}

extension SocialAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/api/users/kakao"
            
        case .kakaoProfile:
            return "/api/users/kakao/profile"
            
        case .appleLogin:
            return "/api/users/apple"
            
        case .appleProfile:
            return "/api/users/apple/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .kakaoProfile,
             .appleLogin, .appleProfile:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .kakaoLogin(body),
            let .appleLogin(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .kakaoProfile(body),
            let .appleProfile(body):
            return .uploadMultipart(body.toMultipartFormData())
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .kakaoLogin,
                .appleLogin:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value]
            
        case .kakaoProfile,
                .appleProfile:
            return [Header.contentTypeJson.key: Header.contentTypeMulti.value]
        }
    }
}
