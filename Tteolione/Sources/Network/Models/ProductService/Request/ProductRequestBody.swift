//
//  ProductRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductRequestBody: Encodable {
    
    let categoryId: String
    let title: String
    let buyPrice: Int
    let buyCount: Int
    let sharePrice: Int
    let shareCount: Int
    let buyDate: String
    let description: String
    let longitude: Double
    let latitude: Double
    
}
