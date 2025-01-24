//
//  Constants.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation

enum LoginTypeKey: String {
    case kakao
    case apple
    case local
}

struct ProfileMenuItem: Equatable {
    let title: String
}
