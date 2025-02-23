//
//  ProductFilterListDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductFilterListDTO: Equatable, Decodable {
    
    let content: [ProductPreviewDTO]
    let pageable: PageableDTO
    let size: Int
    let number: Int
    let sort: [PageSortDTO]
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
    
}

struct PageableDTO: Equatable, Decodable {
    
    let sort: [PageSortDTO]
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
    let paged: Bool
    
}

struct PageSortDTO: Equatable, Decodable {
    
    let direction: String
    let property: String
    let ignoreCase: Bool
    let nullHandling: String
    let descending: Bool
    let ascending: Bool
    
}

extension PageableDTO {
    static let empty = PageableDTO(
        sort: [],
        offset: 0,
        pageNumber: 0,
        pageSize: 0,
        unpaged: false,
        paged: false
    )
}
