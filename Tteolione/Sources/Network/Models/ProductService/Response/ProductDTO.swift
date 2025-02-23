//
//  ProductDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductDTO: Equatable, Decodable {
    
    var list: [ProductListDTO]
    
}

struct ProductListDTO: Equatable, Decodable {
    
    let categoryId: Int
    let categoryName: String
    var products: [ProductPreviewDTO]
    
}

struct ProductPreviewDTO: Decodable, Equatable {
    let productId: Int
    let imageUrl: String
    let title: String
    let unitPrice: Int
    let walkingDistance: Double
    let walkingTime: Int
    var totalLikes: Int
    var liked: Bool
    let soldStatus: String?
    let likeId: Int?

    mutating func toggleLike() {
        liked.toggle()
        totalLikes += liked ? 1 : -1
    }
}


//final class ProductPreviewDTO: Decodable, Identifiable, Equatable {
//    
//    let productId: Int
//    let imageUrl: String
//    let title: String
//    let unitPrice: Int
//    let walkingDistance: Double
//    let walkingTime: Int
//    var totalLikes: Int
//    var liked: Bool
//    let soldStatus: String?
//    let likeId: Int?
//
//    private enum CodingKeys: String, CodingKey {
//        case productId, imageUrl, title, unitPrice, walkingDistance, walkingTime, totalLikes, soldStatus, likeId, liked
//    }
//    
//    init(productId: Int, imageUrl: String, title: String, unitPrice: Int, walkingDistance: Double, walkingTime: Int, totalLikes: Int, soldStatus: String?, likeId: Int?, liked: Bool) {
//        self.productId = productId
//        self.imageUrl = imageUrl
//        self.title = title
//        self.unitPrice = unitPrice
//        self.walkingDistance = walkingDistance
//        self.walkingTime = walkingTime
//        self.totalLikes = totalLikes
//        self.soldStatus = soldStatus
//        self.likeId = likeId
//        self.liked = liked
//    }
//
//    func toggleLike() {
//        liked.toggle()
//        totalLikes += liked ? 1 : -1
//    }
//
//    static func == (lhs: ProductPreviewDTO, rhs: ProductPreviewDTO) -> Bool {
//        return lhs.productId == rhs.productId
//    }
//}
