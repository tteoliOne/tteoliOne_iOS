//
//  ResetPasswordReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ResetPasswordReactor: Reactor {
    
    enum Action {
        case updatePassword(String)
        case backButtonTap
        case passwordResetButtonTap
    }
    
    enum Mutation {
        case updateValidations([Bool])
        case setPassword(String)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }

    struct State {
        var validations: [Bool] = [false, false, false, false, false]
        var password: String = ""
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<FindAccountAPI>
    private let mediator: OnBoardingMediator
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<FindAccountAPI>,
         mediator: OnBoardingMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension ResetPasswordReactor {
    
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
            
        case .passwordResetButtonTap:
            guard currentState.validations.allSatisfy({ $0 }) else { return .empty() }
            let password = currentState.password
            return .concat([
                performResetPassword(password: password)
            ])
        }
    }
    
}

extension ResetPasswordReactor {
    
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
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension ResetPasswordReactor {
    
    private func performResetPassword(password: String) -> Observable<Mutation> {
        let email = mediator.get(\.email)
        let username = mediator.get(\.username)
        let id = mediator.get(\.loginId)
        let body = FindAccountRequestBody(email: email,
                                          username: username,
                                          loginId: id,
                                          password: password)
        return networkProvider
            .request(.resetPassword(body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { [weak self] response -> Observable<Mutation> in
                guard let self = self else {
                    return .empty()
                }
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
