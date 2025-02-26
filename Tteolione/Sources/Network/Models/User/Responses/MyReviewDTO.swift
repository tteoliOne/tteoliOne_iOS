//
//  MyReviewDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct MyReviewDTO: Equatable, Decodable {
    
    let productId: Int
    let reviewId: Int
    let writer: String
    let content: String
    let ddabongScore: Int
    let createAt: String
    let updateAt: String
    
}
