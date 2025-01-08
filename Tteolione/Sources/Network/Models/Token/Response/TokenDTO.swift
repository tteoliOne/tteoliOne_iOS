//
//  TokenDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct TokenDTO: Decodable {
    
    let accessToken: String
    let refreshToken: String
    
}
