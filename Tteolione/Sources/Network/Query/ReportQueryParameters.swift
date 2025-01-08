//
//  ReportQueryParameters.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ReportQueryParameters: QueryStringProtocol {
    
    let reportCategory: String
    
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        items.append(URLQueryItem(name: "reportCategory", value: "\(reportCategory)"))
        
        return items
    }
    
}
