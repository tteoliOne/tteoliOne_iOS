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
    
    var key: String {
        switch self {
        case .contentTypeJson,
                .contentTypeMulti:
            return "Content-Type"
        }
    }
    
    var value: String {
        switch self {
        case .contentTypeJson:
            return "application/json"
            
        case .contentTypeMulti:
            return "multipart/form-data"
        }
        
    }
}
