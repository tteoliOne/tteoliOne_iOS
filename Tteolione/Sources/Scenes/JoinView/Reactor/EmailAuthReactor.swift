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
    }
    
    enum Mutation {
        case setEmail(String)
        case setButtonEnabled(Bool)
    }

    struct State {
        var email: String = ""
        var isButtonEnabled: Bool = false
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    
}

extension EmailAuthReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .emailInputChanged(email):
            let isValid = isValidEmail(email)
            
            return Observable.concat([
                Observable.just(.setEmail(email)),
                Observable.just(.setButtonEnabled(isValid))
            ])
            
        case .backButtonTap:
            backNavigation.onNext(())
            return Observable.empty()
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
        }
        
        return newState
    }
    
}

extension EmailAuthReactor {
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
}
