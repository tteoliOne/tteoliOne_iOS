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
        case showError(NetworkError)
    }
    
    struct State {
        var email: String = ""
        var isButtonEnabled: Bool = false
        var errorMessage: String?
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    private let networkProvider: NetworkProvider<JoinAPI>
    
    init(networkProvider: NetworkProvider<JoinAPI>) {
        self.networkProvider = networkProvider
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
            backNavigation.onNext(())
            return .empty()
            
        case .emailCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            return .concat([
                performEmailCheck(email: currentState.email)
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
                    self.navigateToNextView.onNext(())
                    return .empty()
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
