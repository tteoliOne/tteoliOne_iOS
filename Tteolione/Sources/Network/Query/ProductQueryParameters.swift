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
    let page: Int
    let size: Int
    let sort: String?
    let status: String?
    let q: String?
    
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        items.append(URLQueryItem(name: "longitude", value: "\(longitude)"))
        items.append(URLQueryItem(name: "latitude", value: "\(latitude)"))
        
        if let categoryId = categoryId {
            items.append(URLQueryItem(name: "categoryId", value: "\(categoryId)"))
        }
        
        if let searchStartDate = searchStartDate {
            items.append(URLQueryItem(name: "searchStartDate", value: searchStartDate))
        }
        
        if let searchEndDate = searchEndDate {
            items.append(URLQueryItem(name: "searchEndDate", value: searchEndDate))
        }
        
        items.append(URLQueryItem(name: "page", value: "\(page)"))
        items.append(URLQueryItem(name: "size", value: "\(size)"))
        
        if let sort = sort {
            items.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let status = status {
            items.append(URLQueryItem(name: "status", value: sort))
        }
        
        if let q = q {
            items.append(URLQueryItem(name: "q", value: q))
        }
        
        return items
    }
    
}
