//
//  ReissueTokenRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ReissueTokenRequestBody: Encodable {
    
    let accessToken: String
    let refreshToken: String
    let targetToken: String?
    
}
