//
//  JoinRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 12/15/24.
//

import Foundation

struct JoinRequestBody: Encodable {
    
    let email: String?
    let code: String?
    let username: String?
    let loginId: String?
    let nickname: String?
    let password: String?
    
    init(email: String? = nil,
         code: String? = nil,
         username: String? = nil,
         loginId: String? = nil,
         nickname: String? = nil,
         password: String? = nil) {
        self.email = email
        self.code = code
        self.username = username
        self.loginId = loginId
        self.nickname = nickname
        self.password = password
    }
    
}
