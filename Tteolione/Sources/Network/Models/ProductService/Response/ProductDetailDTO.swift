//
//  ProductDetailDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductDetailDTO: Equatable, Decodable {
    
    let productId: Int
    let categoryId: Int
    let images: [String]
    let sellerProfile: String
    let receipt: String
    let sellerId: Int
    let sellerNickname: String
    let title: String
    let buyDate: String
    let likeCount: Int
    let buyCount: Int
    let buyPrice: Int
    let shareCount: Int
    let sharePrice: Int
    let description: String
    let longitude: Double
    let latitude: Double
    let likeId: Int?
    let checkLiked: Bool
    let checkOwner: Bool
    let soldStatus: String
    
}
