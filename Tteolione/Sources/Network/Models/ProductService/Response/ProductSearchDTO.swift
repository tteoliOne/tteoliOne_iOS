//
//  ProductSearchDTO.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ProductSearchDTO: Decodable {
    
    let q: String
    let list: ProductFilterListDTO
    
}
