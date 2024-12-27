//
//  EmailAuthReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import Foundation
import ReactorKit
import RxSwift

final class EmailAuthReactor: Reactor {
    
    enum Action {
        case emailInputChanged(String)
        case backButtonTap
        case emailCheckButtonTap
    }
    
    enum Mutation {
        case setEmail(String)
        case setButtonEnabled(Bool)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var email: String = ""
        var isButtonEnabled: Bool = false
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
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

extension EmailAuthReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .emailInputChanged(email):
            let isValid = isValidEmail(email)
            
            return .concat([
                .just(.setEmail(email)),
                .just(.setButtonEnabled(isValid))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .emailCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            let email = currentState.email
            return .concat([
                performEmailCheck(email: email)
            ])
        }
    }
    
}

extension EmailAuthReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setEmail(email):
            newState.email = email
            
        case let .setButtonEnabled(isEnabled):
            newState.isButtonEnabled = isEnabled
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension EmailAuthReactor {
    
    private func performEmailCheck(email: String) -> Observable<Mutation> {
        let body = JoinRequestBody(email: email)
        return networkProvider
            .request(.joinEmail(body: body), decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let message):
                    self.mediator.update(email, action: SignUpReactor.Action.updateEmail)
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}

extension EmailAuthReactor {
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
}
