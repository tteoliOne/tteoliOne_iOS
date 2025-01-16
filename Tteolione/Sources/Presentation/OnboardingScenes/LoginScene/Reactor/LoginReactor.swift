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
        case loginButtonTap
        case updateId(String)
        case updatePassword(String)
    }
    
    enum Mutation {
        case setEmailLabelPosition(up: Bool)
        case setPasswordLabelPosition(up: Bool)
        case togglePasswordSecureMode
        case setSignUpToNext(Bool)
        case setFindIDToNext(Bool)
        case setLoginButtonEnabled([Bool])
        case setLoginToNext(Bool)
        case setId(String)
        case setPassword(String)
        case showError(NetworkError)
    }

    struct State {
        var isEmailLabelUp: Bool = false
        var isPasswordLabelUp: Bool = false
        var isPasswordSecure: Bool = true
        var isSignUpToNext: Bool = false
        var isFindIDToNext: Bool = false
        var isLoginButtonEnabled: [Bool] = [false, false]
        var isLoginToNext: Bool = false
        var id: String = ""
        var password: String = ""
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<UserSessionAPI>
    private let ud: UserDefaultsManager
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserSessionAPI>,
         ud: UserDefaultsManager) {
        self.networkProvider = networkProvider
        self.ud = ud
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
                performLogin(id: id,
                             password: password)
            ])
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
        }
        
        return newState
    }
    
}

extension LoginReactor {
    
    private func performLogin(id: String,
                              password: String) -> Observable<Mutation> {
        let body = LoginRequestBody(loginId: id,
                                    password: password,
                                    targetToken: "")
        return networkProvider.request(.login(body: body),
                                       decodingType: ServerResponse<UserDTO>.self)
        .asObservable()
        .flatMap { [weak self] response -> Observable<Mutation> in
            guard let self = self else {
                return .empty()
            }
            switch handleResponse(response) {
            case .success(let result):
                self.ud.nickname = result.nickname
                self.ud.token = result.accessToken
                self.ud.refreshToken = result.refreshToken
                self.ud.userID = result.userId
                self.ud.typeLogin = .local
                return .concat([
                    .just(.setLoginToNext(true)),
                    .just(.setLoginToNext(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
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
