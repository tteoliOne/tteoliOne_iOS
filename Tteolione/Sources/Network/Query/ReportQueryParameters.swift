//
//  ReportQueryParameters.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ReportQueryParameters: QueryStringProtocol {
    
    let reportCategory: String
    
    func asQueryItems() -> [String : Any] {
        var items: [String : Any] = [:]
        
        items["reportCategory"] = reportCategory
        
        return items
    }
    
}
