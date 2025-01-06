//
//  FindIDReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import Foundation
import ReactorKit
import RxSwift

final class FindIDReactor: Reactor {
    
    enum Action {
        case updateUsername(String)
        case updateEmail(String)
        case backButtonTap
        case sendAuthButtonTap
    }
    
    enum Mutation {
        case setUsername(String)
        case setEmail(String)
        case setButtonEnabled(Bool)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var username: String = ""
        var email: String = ""
        var isButtonEnabled: Bool = false
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

extension FindIDReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateUsername(let username):
            return .concat([
                .just(.setUsername(username)),
                .just(.setButtonEnabled(isValidName(username) && isValidEmail(currentState.email)))
            ])
            
        case .updateEmail(let email):
            return .concat([
                .just(.setEmail(email)),
                .just(.setButtonEnabled(isValidName(currentState.username) && isValidEmail(email)))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .sendAuthButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            let email = currentState.email
            let username = currentState.username
            return .concat([
                performEmailCheck(username: username,
                                  email: email)
            ])
        }
    }
    
}

extension FindIDReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUsername(let username):
            newState.username = username
            
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

extension FindIDReactor {
    
    private func performEmailCheck(username: String, email: String) -> Observable<Mutation> {
        let body = FindAccountRequestBody(email: email,
                                          username: username)
        return networkProvider
            .request(.findID(body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { [weak self] response -> Observable<Mutation> in
                guard let self = self else {
                    return .empty()
                }
                switch handleResponse(response) {
                case .success(let message):
                    self.mediator.update(email, action: OnBoardingReactor.Action.updateEmail)
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidName(_ username: String) -> Bool {
        return username.count >= 1
    }
    
}
