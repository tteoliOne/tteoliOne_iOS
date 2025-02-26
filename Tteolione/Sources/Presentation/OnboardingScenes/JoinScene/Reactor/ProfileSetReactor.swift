//
//  ProfileSetReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import RxSwift
import ReactorKit

final class ProfileSetReactor: Reactor {
    
    enum Action {
        case backButtonTap
        case imageSelected(UIImage)
        case joinButtonTap
    }
    
    enum Mutation {
        case setProfileImage(UIImage)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }

    struct State {
        var profileImage: UIImage? = nil
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
        var token: String? = ""
    }
    
    enum LoginType {
        case local(NetworkProvider<JoinAPI>)
        case kakao(NetworkProvider<SocialAPI>)
        case apple(NetworkProvider<SocialAPI>)
    }
    
    private let loginType: LoginType
    private let mediator: OnBoardingMediator
    var initialState: State = State()
    
    init(loginType: LoginType,
         mediator: OnBoardingMediator,
         token: String? = "") {
        self.loginType = loginType
        self.mediator = mediator
        self.initialState = State(token: token)
    }
    
}

extension ProfileSetReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case let .imageSelected(image):
            return Observable.concat([
                .just(.setProfileImage(image))
            ])
            
        case .joinButtonTap:
            guard let profileImage = currentState.profileImage else {
                return .just(.showError(NetworkError.invalidInputImage))
            }
//            return performLocalSetImageProfile(profile: profileImage)
            switch loginType {
            case .local(let network):
                return performLocalSetImageProfile(networkProvider: network,
                                                   profile: profileImage)
            case .kakao(let network):
                return performKakaoSetImageProfile(networkProvider: network,
                                                   token: currentState.token ?? "",
                                                   profile: profileImage)
            case .apple(let network):
                return performAppleSetImageProfile(networkProvider: network,
                                                   token: currentState.token ?? "",
                                                   profile: profileImage)
                
            }
        }
    }
}

extension ProfileSetReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setProfileImage(image):
            newState.profileImage = image
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
}

extension ProfileSetReactor {
    
    private func performLocalSetImageProfile(networkProvider: NetworkProvider<JoinAPI>,
                                             profile: UIImage) -> Observable<Mutation> {
        
        let email = mediator.get(\OnBoardingReactor.State.email)
        let username = mediator.get(\OnBoardingReactor.State.username)
        let loginId = mediator.get(\OnBoardingReactor.State.loginId)
        let nickname = mediator.get(\OnBoardingReactor.State.nickname)
        let password = mediator.get(\OnBoardingReactor.State.password)
        
        guard let profileImageData = profile.jpegData(compressionQuality: 0.8) else {
            return .just(.showError(NetworkError.invalidInputImage))
        }
        
        let signUpRequest = JoinRequestBody(
            email: email,
            username: username,
            loginId: loginId,
            nickname: nickname,
            password: password
        )

        let body = SignUpProfileImageRequestBody(
            signUpRequest: signUpRequest,
            image: profileImageData
        )
        
        return networkProvider
            .request(.signUp(body: body), decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func performKakaoSetImageProfile(networkProvider: NetworkProvider<SocialAPI>,
                                             token: String,
                                             profile: UIImage) -> Observable<Mutation> {
        guard let profileImageData = profile.jpegData(compressionQuality: 0.8) else {
            return .just(.showError(NetworkError.invalidInputImage))
        }
        let fcmToken = UserDefaultsStorage.fcmToken
        let signUpRequest = SocialRequestBody(accessToken: token,
                                              targetToken: fcmToken)
        let body = SocialProfileImageRequestBody(socialRequest: signUpRequest,
                                                 image: profileImageData,
                                                 requestName: "oAuth2KakaoRequest")
        
        return networkProvider
            .request(.kakaoProfile(body: body), decodingType: ServerResponse<UserDTO>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let result):
                    UserDefaultsStorage.nickname = result.nickname ?? ""
                    UserDefaultsStorage.token = result.accessToken ?? ""
                    UserDefaultsStorage.refreshToken = result.refreshToken ?? ""
                    UserDefaultsStorage.userID = result.userId ?? 0
                    UserDefaultsStorage.typeLogin = LoginTypeKey.kakao.rawValue
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func performAppleSetImageProfile(networkProvider: NetworkProvider<SocialAPI>,
                                             token: String,
                                             profile: UIImage) -> Observable<Mutation> {
        guard let profileImageData = profile.jpegData(compressionQuality: 0.8) else {
            return .just(.showError(NetworkError.invalidInputImage))
        }
        let fcmToken = UserDefaultsStorage.fcmToken
        let signUpRequest = SocialRequestBody(targetToken: fcmToken,
                                              appleRefreshToken: token)
        let body = SocialProfileImageRequestBody(socialRequest: signUpRequest,
                                                 image: profileImageData,
                                                 requestName: "oAuth2AppleRequest")
        
        return networkProvider
            .request(.appleProfile(body: body), decodingType: ServerResponse<UserDTO>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let result):
                    UserDefaultsStorage.nickname = result.nickname ?? ""
                    UserDefaultsStorage.token = result.accessToken ?? ""
                    UserDefaultsStorage.refreshToken = result.refreshToken ?? ""
                    UserDefaultsStorage.userID = result.userId ?? 0
                    UserDefaultsStorage.typeLogin = LoginTypeKey.apple.rawValue
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}
