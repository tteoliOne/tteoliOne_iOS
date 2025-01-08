//
//  HeaderKeyAndValue.swift
//  Tteolione
//
//  Created by 전준영 on 12/15/24.
//

import Foundation

enum Header {
    
    case contentTypeJson
    case contentTypeMulti
    case authorization
    
    var key: String {
        switch self {
        case .contentTypeJson,
                .contentTypeMulti:
            return "Content-Type"
            
        case .authorization:
            return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .contentTypeJson:
            return "application/json"
            
        case .contentTypeMulti:
            return "multipart/form-data"
            
        case .authorization:
            let token = UserDefaultsManager.shared.token
            return "Bearer \(token)"
        }
        
    }
}
