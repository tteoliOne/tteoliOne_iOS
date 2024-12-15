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
    let loginId: String?
    let nickname: String?
    let password: String?
    
}
