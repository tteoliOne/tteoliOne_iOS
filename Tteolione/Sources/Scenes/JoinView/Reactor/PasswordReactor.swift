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
        case passwordCheckButtonTap
    }
    
    enum Mutation {
        case updateValidations([Bool])
        case setPassword(String)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
    }

    struct State {
        var validations: [Bool] = [false, false, false, false, false]
        var password: String = ""
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
    }
    
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: SignUpMediator
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<JoinAPI>,
         mediator: SignUpMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension PasswordReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updatePassword(password):
            let validations = validatePassword(password)
            return .concat([
                .just(.updateValidations(validations)),
                .just(.setPassword(password))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .passwordCheckButtonTap:
            let password = currentState.password
            mediator.update(password,
                            action: SignUpReactor.Action.updatePassword)
            return .concat([
                .just(.setNavigateToNext(true)),
                .just(.setNavigateToNext(false))
            ])
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
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
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
