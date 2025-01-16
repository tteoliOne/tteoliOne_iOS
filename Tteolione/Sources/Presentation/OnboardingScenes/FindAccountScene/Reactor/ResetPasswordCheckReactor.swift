//
//  ResetPasswordCheckReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ResetPasswordCheckReactor: Reactor {
    
    enum Action {
        case updateUsername(String)
        case updateId(String)
        case updateEmail(String)
        case backButtonTap
        case sendAuthButtonTap
    }
    
    enum Mutation {
        case setUsername(String)
        case setId(String)
        case setEmail(String)
        case setButtonEnabled([Bool])
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var username: String = ""
        var id: String = ""
        var email: String = ""
        var isButtonEnabled: [Bool] = [false, false, false]
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<FindAccountAPI>
    private let mediator: OnBoardingMediator
    let initialState = State()
    
    init(networkProvider: NetworkProvider<FindAccountAPI>,
         mediator: OnBoardingMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension ResetPasswordCheckReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateUsername(let username):
            return .concat([
                .just(.setUsername(username)),
                .just(.setButtonEnabled(updateButtonState(at: 0, isValid: isValidCount(username))))
            ])
            
        case .updateId(let id):
            return .concat([
                .just(.setId(id)),
                .just(.setButtonEnabled(updateButtonState(at: 1, isValid: isValidCount(id))))
            ])
            
        case .updateEmail(let email):
            return .concat([
                .just(.setEmail(email)),
                .just(.setButtonEnabled(updateButtonState(at: 2, isValid: isValidEmail(email))))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .sendAuthButtonTap:
            guard currentState.isButtonEnabled.allSatisfy({ $0 }) else { return .empty() }
            let email = currentState.email
            let id = currentState.id
            let username = currentState.username
            return .concat([
                performEmailCheck(username: username,
                                  id: id,
                                  email: email)
            ])
        }
    }
    
}

extension ResetPasswordCheckReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUsername(let username):
            newState.username = username
            
        case .setId(let id):
            newState.id = id
            
        case .setEmail(let email):
            newState.email = email
            
        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
            
        case .setNavigateToNext(let navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case .setNavigateBack(let navigateBack):
            newState.navigateBack = navigateBack
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension ResetPasswordCheckReactor {
    
    private func performEmailCheck(username: String,
                                   id: String,
                                   email: String) -> Observable<Mutation> {
        let body = FindAccountRequestBody(email: email,
                                          username: username,
                                          loginId: id)
        return networkProvider
            .request(.findPassword(body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { [weak self] response -> Observable<Mutation> in
                guard let self = self else {
                    return .empty()
                }
                switch handleResponse(response) {
                case .success(_):
                    self.mediator.update(email, action: OnBoardingReactor.Action.updateEmail)
                    self.mediator.update(id, action: OnBoardingReactor.Action.updateID)
                    self.mediator.update(username, action: OnBoardingReactor.Action.updateUsername)
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func updateButtonState(at index: Int,
                                   isValid: Bool) -> [Bool] {
        var buttonEnabled = currentState.isButtonEnabled
        buttonEnabled[index] = isValid
        return buttonEnabled
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidCount(_ str: String) -> Bool {
        return str.count >= 1
    }
    
}
