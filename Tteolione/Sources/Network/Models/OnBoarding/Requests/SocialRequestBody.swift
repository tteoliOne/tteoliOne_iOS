//
//  SocialRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct SocialRequestBody: Encodable {
    
    let accessToken: String?
    let targetToken: String?
    let authorization: String?
    let appleRefreshToken: String?
    
    init(accessToken: String? = nil,
         authorization: String? = nil,
         targetToken: String? = nil,
         appleRefreshToken: String? = nil) {
        self.accessToken = accessToken
        self.authorization = authorization
        self.targetToken = targetToken
        self.appleRefreshToken = appleRefreshToken
    }
    
}
