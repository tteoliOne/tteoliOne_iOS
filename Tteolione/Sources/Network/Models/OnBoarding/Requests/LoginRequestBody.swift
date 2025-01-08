//
//  LoginRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct LoginRequestBody: Encodable {
    
    let loginId: String
    let password: String
    let targetToken: String
    
}
