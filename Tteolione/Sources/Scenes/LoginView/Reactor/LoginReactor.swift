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
    }
    
    enum Mutation {
        case setEmailLabelPosition(up: Bool)
        case setPasswordLabelPosition(up: Bool)
        case togglePasswordSecureMode
    }

    struct State {
        var isEmailLabelUp: Bool = false
        var isPasswordLabelUp: Bool = false
        var isPasswordSecure: Bool = true
    }
    
    let initialState: State = State()
    
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
        }
        
        return newState
    }
    
}
