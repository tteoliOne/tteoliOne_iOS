//
//  UserProfileDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct UserProfileDTO: Decodable {
    
    let profile: String
    let nickname: String
    let intro: String?
    let thumbsUpScore: Double
    
}
