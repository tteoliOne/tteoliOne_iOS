//
//  Constants.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation

struct Constants {
    
    static let productCategories = [
        "채소",
        "과일",
        "간편식",
        "정육",
        "수산물",
        "기타"
    ]
    
}

enum LoginTypeKey: String {
    case kakao
    case apple
    case local
}
