//
//  OtherUserDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct OtherUserDTO: Equatable, Decodable {
    
    let profile: String
    let nickname: String
    let intro: String?
    let ddabongScore: Double
    let newProductCount: Int
    let soldOutProductCount: Int
    let reviewCount: Int
    
}
