//
//  UserDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct UserDTO: Decodable {
    
    let exsitsUser: Bool
    let nickname: String
    let userId: String
    let accessToken: String
    let refreshToken: String
    let appleRefreshToken: String?
    
}
