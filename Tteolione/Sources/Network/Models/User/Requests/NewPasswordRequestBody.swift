//
//  NewPasswordRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct NewPasswordRequestBody: Encodable {
    
    let passwrod: String
    let newPassword: String
    let newPasswordConfirm: String
    
}
