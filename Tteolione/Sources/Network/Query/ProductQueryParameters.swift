//
//  ProductQueryParameters.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductQueryParameters: QueryStringProtocol {
    
    let longitude: Double
    let latitude: Double
    let categoryId: Int?
    let searchStartDate: String?
    let searchEndDate: String?
    let page: Int?
    let size: Int?
    let sort: String?
    let status: String?
    let q: String?
    
    init(longitude: Double,
         latitude: Double,
         categoryId: Int? = nil,
         searchStartDate: String? = nil,
         searchEndDate: String? = nil,
         page: Int? = nil ,
         size: Int? = nil,
         sort: String? = nil,
         status: String? = nil,
         q: String? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.categoryId = categoryId
        self.searchStartDate = searchStartDate
        self.searchEndDate = searchEndDate
        self.page = page
        self.size = size
        self.sort = sort
        self.status = status
        self.q = q
    }
    
    func asQueryItems() -> [String : Any] {
        var items: [String : Any] = [:]
        
        
        items["longitude"] = longitude
        items["latitude"] = latitude
        
        if let categoryId = categoryId {
            items["categoryId"] = categoryId
        }
        
        if let searchStartDate = searchStartDate {
            items["searchStartDate"] = searchStartDate
        }
        
        if let searchEndDate = searchEndDate {
            items["searchEndDate"] = searchEndDate
        }
        
        if let page = page {
            items["page"] = page
        }
        
        if let size = size {
            items["size"] = size
        }
        
        if let sort = sort {
            items["sort"] = sort
        }
        
        if let status = status {
            items["status"] = status
        }
        
        if let q = q {
            items["q"] = q
        }
        
        return items
    }
    
}
