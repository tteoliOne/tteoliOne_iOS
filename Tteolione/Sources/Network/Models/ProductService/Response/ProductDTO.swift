//
//  ProductDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductDTO: Equatable, Decodable {
    
    let list: [ProductListDTO]
    
}

struct ProductListDTO: Equatable, Decodable {
    
    let categoryId: Int
    let categoryName: String
    let products: [ProductPreviewDTO]
    
}

struct ProductPreviewDTO: Equatable, Decodable {
    
    let productId: Int
    let imageUrl: String
    let title: String
    let unitPrice: Int
    let walkingDistance: Double
    let walkingTime: Int
    let totalLikes: Int
    let soldStatus: String?
    let likeId: Int?
    let liked: Bool
    
}
