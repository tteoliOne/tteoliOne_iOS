//
//  SignUpReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/18/24.
//

import Foundation
import ReactorKit
import RxSwift

final class SignUpReactor: Reactor {
    
    enum Action {
        case updateEmail(String)
        case updateAuthCode(String)
        case updateID(String)
        case updatePassword(String)
        case updateNickname(String)
    }
    
    enum Mutation {
        case setEmail(String)
        case setAuthCode(String)
        case setID(String)
        case setPassword(String)
        case setNickname(String)
    }
    
    struct State {
        var email: String = ""
        var code: String = ""
        var loginId: String = ""
        var password: String = ""
        var nickname: String = ""
    }
    
    let initialState = State()
    
}

extension SignUpReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateEmail(email):
            return .just(.setEmail(email))
            
        case let .updateAuthCode(authCode):
            return .just(.setAuthCode(authCode))
            
        case let .updateID(loginId):
            return .just(.setID(loginId))
            
        case let .updatePassword(password):
            return .just(.setPassword(password))
            
        case let .updateNickname(nickname):
            return .just(.setNickname(nickname))
        }
    }
    
}

extension SignUpReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEmail(email):
            newState.email = email
            
        case let .setAuthCode(code):
            newState.code = code
            
        case let .setID(id):
            newState.loginId = id
            
        case let .setPassword(password):
            newState.password = password
            
        case let .setNickname(nickname):
            newState.nickname = nickname
        }
        
        return newState
    }
    
}
