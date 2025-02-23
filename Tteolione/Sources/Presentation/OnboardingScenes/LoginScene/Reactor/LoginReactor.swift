//
//  LoginReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import ReactorKit
import RxSwift

final class LoginReactor: Reactor {
    
    enum Action {
        case emailTextFieldTapBegin
        case emailTextFieldTapEnd
        case passwordTextFieldTapBegin
        case passwordTextFieldTapEnd
        case passwordSecureButtonTap
        case signUpButtonTap
        case idSearchButtonTap
        case resetPasswordButtonTap
        case loginButtonTap
        case updateId(String)
        case updatePassword(String)
        case kakaoButtonTap
        case appleButtonTap
    }
    
    enum Mutation {
        case setEmailLabelPosition(up: Bool)
        case setPasswordLabelPosition(up: Bool)
        case togglePasswordSecureMode
        case setSignUpToNext(Bool)
        case setFindIDToNext(Bool)
        case setPasswordToNext(Bool)
        case setLoginButtonEnabled([Bool])
        case setLoginToNext(Bool)
        case setId(String)
        case setPassword(String)
        case showError(NetworkError)
        case clearErrorMessage
        case setKakaoLoginToAddress(Bool)
        case setKakaoLoginToProfile(Bool)
        case setToken(String?)
        case setKakaoErrorMessage(String)
        case setAppleLoginToAddress(Bool)
        case setAppleLoginToProfile(Bool)
        case setAppleErrorMessage(String)
        case setLoading(Bool)
    }

    struct State {
        var isEmailLabelUp: Bool = false
        var isPasswordLabelUp: Bool = false
        var isPasswordSecure: Bool = true
        var isSignUpToNext: Bool = false
        var isFindIDToNext: Bool = false
        var isPasswordToNext: Bool = false
        var isLoginButtonEnabled: [Bool] = [false, false]
        var isLoginToNext: Bool = false
        var id: String = ""
        var password: String = ""
        var errorMessage: String?
        var isKakaoLoginToAddress: Bool = false
        var isKakaoLoginToProfile: Bool = false
        var token: String = ""
        var isAppleLoginToAddress: Bool = false
        var isAppleLoginToProfile: Bool = false
        var isLoading: Bool = false
    }
    
    private let kakaoAuthVM: KakaoAuthVM
    private let appleAuthManager: AppleAuthManager
    private let networkProvider: NetworkProvider<UserSessionAPI>
    let initialState: State = State()
    
    init(kakaoAuthVM: KakaoAuthVM,
         appleAuthManager: AppleAuthManager,
         networkProvider: NetworkProvider<UserSessionAPI>) {
        self.kakaoAuthVM = kakaoAuthVM
        self.appleAuthManager = appleAuthManager
        self.networkProvider = networkProvider
    }
    
}

extension LoginReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emailTextFieldTapBegin:
            return Observable.just(.setEmailLabelPosition(up: true))
            
        case .emailTextFieldTapEnd:
            return Observable.just(.setEmailLabelPosition(up: false))
            
        case .passwordTextFieldTapBegin:
            return Observable.just(.setPasswordLabelPosition(up: true))
            
        case .passwordTextFieldTapEnd:
            return Observable.just(.setPasswordLabelPosition(up: false))
            
        case .passwordSecureButtonTap:
            return Observable.just(.togglePasswordSecureMode)
            
        case .signUpButtonTap:
            return .concat([
                .just(.setSignUpToNext(true)),
                .just(.setSignUpToNext(false))
            ])
            
        case .idSearchButtonTap:
            return .concat([
                .just(.setFindIDToNext(true)),
                .just(.setFindIDToNext(false))
            ])
            
        case .resetPasswordButtonTap:
            return .concat([
                .just(.setPasswordToNext(true)),
                .just(.setPasswordToNext(false))
            ])
            
        case .updateId(let id):
            return .concat([
                .just(.setLoginButtonEnabled(updateLoginButtonState(at: 0, isValid: isValidCount(id)))),
                .just(.setId(id))
            ])
                
            
        case .updatePassword(let password):
            return .concat([
                .just(.setLoginButtonEnabled(updateLoginButtonState(at: 1, isValid: isValidCount(password)))),
                .just(.setPassword(password))
            ])
            
        case .loginButtonTap:
            guard currentState.isLoginButtonEnabled.allSatisfy({ $0 }) else { return .empty() }
            
            let id = currentState.id
            let password = currentState.password
            return .concat([
                .just(.setLoading(true)),
                performLogin(id: id,
                             password: password),
                .just(.setLoading(false))
            ])
            
        case .kakaoButtonTap:
            return kakaoAuthVM.loginWithKakao()
                .asObservable()
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .existingUser:
                        return .concat([
                            .just(.setLoading(true)),
                            .just(.setKakaoLoginToAddress(true)),
                            .just(.setKakaoLoginToAddress(false)),
                            .just(.setLoading(false))
                        ])
                        
                    case .newUser(let accessToken):
                        return .concat([
                            .just(.setLoading(true)),
                            .just(.setToken(accessToken)),
                            .just(.setKakaoLoginToProfile(true)),
                            .just(.setKakaoLoginToProfile(false)),
                            .just(.setLoading(false))
                        ])
                        
                    case .failure(let message):
                        return .just(.setKakaoErrorMessage(message))
                    }
                }
            
        case .appleButtonTap:
            return appleAuthManager.handleAppleSignIn()
                .asObservable()
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .existingUser:
                        return .concat([
                            .just(.setLoading(true)),
                            .just(.setAppleLoginToAddress(true)),
                            .just(.setAppleLoginToAddress(false)),
                            .just(.setLoading(false))
                        ])
                        
                    case .newUser(let accessToken):
                        return .concat([
                            .just(.setLoading(true)),
                            .just(.setToken(accessToken)),
                            .just(.setAppleLoginToProfile(true)),
                            .just(.setAppleLoginToProfile(false)),
                            .just(.setLoading(false))
                        ])
                        
                    case .failure(let message):
                        return .just(.setAppleErrorMessage(message))
                    }
                }
        }
    }
    
}

extension LoginReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEmailLabelPosition(up):
            newState.isEmailLabelUp = up
            
        case let .setPasswordLabelPosition(up):
            newState.isPasswordLabelUp = up
            
        case .togglePasswordSecureMode:
            newState.isPasswordSecure.toggle()
            
        case let .setSignUpToNext(isNavi):
            newState.isSignUpToNext = isNavi
            
        case let .setFindIDToNext(isNavi):
            newState.isFindIDToNext = isNavi
            
        case let .setPasswordToNext(isNavi):
            newState.isPasswordToNext = isNavi
            
        case let .setId(id):
            newState.id = id
            
        case let .setPassword(password):
            newState.password = password
            
        case let .setLoginButtonEnabled(isEnabled):
            newState.isLoginButtonEnabled = isEnabled
            
        case let .setLoginToNext(isNavi):
            newState.isLoginToNext = isNavi
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
            
        case let .setKakaoLoginToAddress(isNavi):
            newState.isKakaoLoginToAddress = isNavi
            
        case let .setKakaoLoginToProfile(isNavi):
            newState.isKakaoLoginToProfile = isNavi
            
        case let .setKakaoErrorMessage(message):
            newState.errorMessage = message

        case let .setToken(token):
            newState.token = token ?? ""
            
        case let .setAppleLoginToAddress(isNavi):
            newState.isAppleLoginToAddress = isNavi
            
        case let .setAppleLoginToProfile(isNavi):
            newState.isAppleLoginToProfile = isNavi
            
        case let .setAppleErrorMessage(message):
            newState.errorMessage = message
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case .clearErrorMessage:
            newState.errorMessage = nil
        }
        
        return newState
    }
    
}

extension LoginReactor {
    
    private func performLogin(id: String,
                              password: String) -> Observable<Mutation> {
        let fcmtoken = UserDefaultsStorage.fcmToken
        let body = LoginRequestBody(loginId: id,
                                    password: password,
                                    targetToken: fcmtoken)
        return .concat([
            .just(.clearErrorMessage),
            networkProvider.request(.login(body: body),
                                    decodingType: ServerResponse<UserDTO>.self)
            .asObservable()
            .catch { error in
                if let networkError = error as? NetworkError {
                    return .just(ServerResponse<UserDTO>(success: false, code: -1, message: networkError.errorDescription, data: nil))
                }
                return .just(ServerResponse<UserDTO>(success: false, code: -1, message: "알 수 없는 오류", data: nil))
            }
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let result):
                    UserDefaultsStorage.nickname = result.nickname ?? ""
                    UserDefaultsStorage.token = result.accessToken ?? ""
                    UserDefaultsStorage.refreshToken = result.refreshToken ?? ""
                    UserDefaultsStorage.userID = result.userId ?? 0
                    UserDefaultsStorage.typeLogin = LoginTypeKey.local.rawValue
                    return .concat([
                        .just(.setLoginToNext(true)),
                        .just(.setLoginToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
        ])
    }
    
    private func updateLoginButtonState(at index: Int, isValid: Bool) -> [Bool] {
        var loginButtonEnabled = currentState.isLoginButtonEnabled
        loginButtonEnabled[index] = isValid
        return loginButtonEnabled
    }
    
    private func isValidCount(_ str: String) -> Bool {
        return str.count >= 1
    }
    
}
