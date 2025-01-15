//
//  AppDependency.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import Foundation

final class AppDependency {
    
    static let shared = AppDependency()
    let ud = UserDefaultsManager()
    let onboardingReactor = OnBoardingReactor()
    let userSessionProvider = NetworkProvider<UserSessionAPI>()
    let joinNetworkProvider = NetworkProvider<JoinAPI>()
    let accountNetworkProvider = NetworkProvider<FindAccountAPI>()
    lazy var onboardingMediator = DefaultOnBoardingMediator(signUpReactor: onboardingReactor)

    private init() {}
}
