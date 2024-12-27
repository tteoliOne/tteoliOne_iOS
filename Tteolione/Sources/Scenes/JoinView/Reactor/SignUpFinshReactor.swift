//
//  SignUpFinshReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import Foundation
import ReactorKit
import RxSwift

final class SignUpFinshReactor: Reactor {
    
    enum Action {
        case signUpFishButtonTap
    }
    
    enum Mutation {
        case setNavigateToNext(Bool)
    }
    
    struct State {
        var navigateToNext: Bool = false
    }
    
    let initialState: State = State()
    
}

extension SignUpFinshReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signUpFishButtonTap:
            return .concat([
                .just(.setNavigateToNext(true)),
                .just(.setNavigateToNext(false))
            ])
        }
    }
    
}

extension SignUpFinshReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
        }
        
        return newState
    }
    
}
