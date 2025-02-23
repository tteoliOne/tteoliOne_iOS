//
//  KakaoAuthVM.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

enum SocialLoginResult {
    case existingUser
    case newUser(accessToken: String)
    case failure(message: String)
}

final class KakaoAuthVM {
    
    // MARK: - Public Properties
    let isLoggedIn = BehaviorRelay<Bool>(value: false)
    let showProfileSetup = PublishRelay<String>()
    let showAddressSetup = PublishRelay<Bool>()
    let errorMessage = PublishRelay<String>()
    
    // MARK: - Private Properties
    private let networkManager: NetworkProvider<SocialAPI>
    
    init(networkManager: NetworkProvider<SocialAPI>) {
        self.networkManager = networkManager
    }
    
    // MARK: - Login with Kakao
    func loginWithKakao() -> Observable<SocialLoginResult> {
        let loginObservable: Observable<OAuthToken?>
        
        if UserApi.isKakaoTalkLoginAvailable() {
            loginObservable = loginUsingApp()
        } else {
            loginObservable = loginUsingAccount()
        }
        
        return loginObservable
            .flatMapLatest { [weak self] oauthToken -> Observable<SocialLoginResult> in
                guard let oauthToken = oauthToken else {
                    return Observable.just(.failure(message: "카카오 로그인 토큰 없음"))
                }
                return self?.handlePostLogin(oauthToken: oauthToken).asObservable() ?? Observable.just(.failure(message: "로그인 처리 중 오류"))
            }
    }
    
    private func loginUsingApp() -> Observable<OAuthToken?> {
        return Observable.create { observer in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(oauthToken)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    private func loginUsingAccount() -> Observable<OAuthToken?> {
        return Observable.create { observer in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(oauthToken)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    private func handlePostLogin(oauthToken: OAuthToken) -> Single<SocialLoginResult> {
        let accessToken = oauthToken.accessToken
        let fcmToken = UserDefaultsStorage.fcmToken
        let body = SocialRequestBody(accessToken: accessToken,
                                     targetToken: fcmToken)
        
        return networkManager.request(.kakaoLogin(body: body),
                                      decodingType: ServerResponse<UserDTO>.self)
            .flatMap { response -> Single<SocialLoginResult> in
                switch handleResponse(response) {
                case .success(let data):
                    if data.existsUser {
                        UserDefaultsStorage.token = data.accessToken ?? ""
                        UserDefaultsStorage.refreshToken = data.refreshToken ?? ""
                        UserDefaultsStorage.userID = data.userId ?? 0
                        UserDefaultsStorage.nickname = data.nickname ?? ""
                        UserDefaultsStorage.typeLogin = LoginTypeKey.kakao.rawValue
                        return .just(.existingUser)
                    } else {
                        return .just(.newUser(accessToken: accessToken))
                    }
                    
                case .failure(let error):
                    return .just(.failure(message: "로그인 실패: \(error.localizedDescription)"))
                }
            }
    }
    
    // MARK: - Logout
    func kakaoLogout() -> Observable<Bool> {
        return Observable.create { observer in
            UserApi.shared.logout { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        .do(onNext: { [weak self] success in
            if success {
                self?.isLoggedIn.accept(false)
            }
        })
    }
}
