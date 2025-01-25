//
//  ProductRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductRequestBody: Encodable, Equatable {
    
    let categoryId: Int
    let title: String
    let buyPrice: Int
    let buyCount: Int
    let sharePrice: Int
    let shareCount: Int
    let buyDate: String
    let description: String
    let longitude: Double
    let latitude: Double
    
    static func defaultValue() -> ProductRequestBody {
        return ProductRequestBody(
            categoryId: 0,
            title: "",
            buyPrice: 0,
            buyCount: 0,
            sharePrice: 0,
            shareCount: 0,
            buyDate: "",
            description: "",
            longitude: 0.0,
            latitude: 0.0
        )
    }
    
    // Custom Equatable Implementation (if required)
    static func == (lhs: ProductRequestBody, rhs: ProductRequestBody) -> Bool {
        return lhs.categoryId == rhs.categoryId &&
               lhs.title == rhs.title &&
               lhs.buyPrice == rhs.buyPrice &&
               lhs.buyCount == rhs.buyCount &&
               lhs.sharePrice == rhs.sharePrice &&
               lhs.shareCount == rhs.shareCount &&
               lhs.buyDate == rhs.buyDate &&
               lhs.description == rhs.description &&
               lhs.longitude == rhs.longitude &&
               lhs.latitude == rhs.latitude
    }
}
