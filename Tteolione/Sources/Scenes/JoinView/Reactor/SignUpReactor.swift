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
        case updatePassword(String)
    }
    
    enum Mutation {
        case setEmail(String)
        case setAuthCode(String)
        case setPassword(String)
    }
    
    struct State {
        var email: String = ""
        var authCode: String = ""
        var password: String = ""
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
            
        case let .updatePassword(password):
            return .just(.setPassword(password))
        }
    }
    
}

extension SignUpReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEmail(email):
            newState.email = email
            
        case let .setAuthCode(authCode):
            newState.authCode = authCode
            
        case let .setPassword(password):
            newState.password = password
        }
        
        return newState
    }
    
}
