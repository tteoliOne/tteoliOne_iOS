//
//  SavedProdcutDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct SavedProdcutDTO: Decodable {
    
    let products: [SavedProductDetailDTO]
    
}

struct SavedProductDetailDTO: Decodable {
    
    let productId: Int
    let productImage: String
    let title: String
    let likeId: Int?
    let soldStatus: String
    
}
