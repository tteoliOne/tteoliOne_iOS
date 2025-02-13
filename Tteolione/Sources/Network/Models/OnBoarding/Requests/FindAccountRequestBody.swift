//
//  FindAccountRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import Foundation

struct FindAccountRequestBody: Encodable {
    
    let email: String?
    let username: String?
    let authCode: String?
    let loginId: String?
    let password: String?
    
    init(email: String? = nil,
         authCode: String? = nil,
         username: String? = nil,
         loginId: String? = nil,
         nickname: String? = nil,
         password: String? = nil) {
        self.email = email
        self.authCode = authCode
        self.username = username
        self.loginId = loginId
        self.password = password
    }
    
}
