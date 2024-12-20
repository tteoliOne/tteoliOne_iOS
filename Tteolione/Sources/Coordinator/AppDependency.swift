//
//  AppDependency.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import Foundation

final class AppDependency {
    
    static let shared = AppDependency()
    let signUpReactor = SignUpReactor()
    let networkProvider = NetworkProvider<JoinAPI>()
    lazy var signUpMediator = DefaultSignUpMediator(signUpReactor: signUpReactor)

    private init() {}
}
