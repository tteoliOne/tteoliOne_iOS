//
//  UserAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum UserAPI {
    case resetNickname(body: JoinRequestBody)
    case changePassword(body: NewPasswordRequestBody)
    case myShareProducts(query: ProductQueryParameters)
    case myLikeProducts(query: ProductQueryParameters)
    case updateMyProfile(body: UpdateMyProfileRequestBody)
    case getMyProfile
    case getOtherUserProfile(userId: Int)
    case getOtherUserProduct(userId: Int,
                             query: ProductQueryParameters)
    case getMyReview(userId: Int)
    case reports(reportType: String,
                 id: Int,
                 query: ReportQueryParameters,
                 body: ReportRequestBody)
    case withdrawal(userId: Int,
                    body: WithdrawalRequestBody)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .resetNickname:
            return "/api/users/nickname"
            
        case .changePassword:
            return "/api/users/change/password"
            
        case let .myShareProducts(query):
            var components = URLComponents(string: "/api/products/me")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
            
        case let .myLikeProducts(query):
            var components = URLComponents(string: "/api/products/me/saved")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
            
        case .updateMyProfile:
            return "/api/users"
            
        case .getMyProfile:
            return "/api/users"
            
        case let .getOtherUserProfile(userId):
            return "/api/users/\(userId)/simple"
            
        case let .getOtherUserProduct(userId, query):
            var components = URLComponents(string: "/api/products/users/\(userId)")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
            
        case let .getMyReview(userId):
            return "/api/reviews/\((userId))"
            
        case let .reports(reportType, id, query, _):
            var components = URLComponents(string: " /api/reports/\(reportType)/\(id)")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
            
        case let .withdrawal(userId, _):
            return "/api/users/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .resetNickname, .changePassword,
                .updateMyProfile:
            return .patch
            
        case .myShareProducts, .myLikeProducts,
                .getMyProfile, .getOtherUserProfile,
                .getOtherUserProduct, .getMyReview:
            return .get
            
        case .reports, .withdrawal:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .resetNickname(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .changePassword(body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .reports(_, _, _, body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .withdrawal(_, body):
            return .requestCustomJSONEncodable(body, encoder: JSONEncoder())
            
        case let .updateMyProfile(body):
            return .uploadMultipart(body.toMultipartFormData())
            
        case .myShareProducts, .myLikeProducts,
                .getMyProfile, .getOtherUserProfile,
                .getOtherUserProduct, .getMyReview:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .resetNickname, .changePassword,
                .myShareProducts, .myLikeProducts,
                .getMyProfile, .getOtherUserProfile,
                .getOtherUserProduct, .getMyReview,
                .reports, .withdrawal:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value,
                    Header.authorization.key: Header.authorization.value]
            
        case .updateMyProfile:
            return [Header.contentTypeMulti.key: Header.contentTypeMulti.value,
                    Header.authorization.key: Header.authorization.value]
        }
    }
}
