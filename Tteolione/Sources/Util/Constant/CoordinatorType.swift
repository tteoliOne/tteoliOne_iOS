//
//  CoordinatorType.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import Foundation

enum CoordinatorType {
    case app, login, tab
    
}

enum AccountCoordinator {
    case id, password, idInPassword
}

enum LoginTypeCoordinator {
    case local, kakao, apple
}
