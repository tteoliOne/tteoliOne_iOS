//
//  AppDependency.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import Foundation

final class AppDependency {
    
    static let shared = AppDependency()
    let kakaoManager = KakaoAuthVM(networkManager: NetworkProvider<SocialAPI>())
    let appleManager = AppleAuthManager(networkProvider: NetworkProvider<SocialAPI>())
    let onboardingReactor = OnBoardingReactor()
    let productServiceProvider = NetworkProvider<ProductServiceAPI>()
    let userSessionProvider = NetworkProvider<UserSessionAPI>()
    let joinNetworkProvider = NetworkProvider<JoinAPI>()
    let accountNetworkProvider = NetworkProvider<FindAccountAPI>()
    let socialNetworkProvider = NetworkProvider<SocialAPI>()
    lazy var onboardingMediator = DefaultOnBoardingMediator(signUpReactor: onboardingReactor)

    private init() {}
}
