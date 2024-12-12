//
//  PasswordReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/12/24.
//

import Foundation
import ReactorKit
import RxSwift

final class PasswordReactor: Reactor {
    
    enum Action {
        case updatePassword(String)
        case backButtonTap
    }
    
    enum Mutation {
        case updateValidations([Bool])
        case setPassword(String)
    }

    struct State {
        var validations: [Bool] = [false, false, false, false, false]
        var password: String = ""
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
}

extension PasswordReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updatePassword(let password):
            let validations = validatePassword(password)
            return .just(.updateValidations(validations))
            
        case .backButtonTap:
            backNavigation.onNext(())
            return Observable.empty()
        }
    }
    
}

extension PasswordReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateValidations(let validations):
            newState.validations = validations
            
        case .setPassword(let password):
            newState.password = password
        }
        return newState
    }
    
}

extension PasswordReactor {
    
    private func validatePassword(_ password: String) -> [Bool] {
        return [
            password.rangeOfCharacter(from: .decimalDigits) != nil,
            password.rangeOfCharacter(from: .symbols) != nil || password.rangeOfCharacter(from: .punctuationCharacters) != nil,
            password.rangeOfCharacter(from: .lowercaseLetters) != nil,
            password.count >= 8 && password.count <= 16,
            password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
        ]
    }
    
}
