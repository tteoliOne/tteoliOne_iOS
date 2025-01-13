//
//  NameReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/28/24.
//

import Foundation
import ReactorKit
import RxSwift

final class NameReactor: Reactor {
    
    enum Action {
        case usernameInputChanged(String)
        case backButtonTap
        case usernameCheckButtonTap
    }
    
    enum Mutation {
        case setUsername(String)
        case setButtonEnabled(Bool)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
    }

    struct State {
        var username: String = ""
        var isButtonEnabled: Bool = false
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
    }
    
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: OnBoardingMediator
    
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<JoinAPI>,
         mediator: OnBoardingMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension NameReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .usernameInputChanged(username):
            let isValid = isValidName(username)
            
            return .concat([
                .just(.setButtonEnabled(isValid)),
                .just(.setUsername(username))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .usernameCheckButtonTap:
            let username = currentState.username
            mediator.update(username,
                            action: OnBoardingReactor.Action.updateUsername)
            return .concat([
                .just(.setNavigateToNext(true)),
                .just(.setNavigateToNext(false))
            ])
        }
    }
    
}

extension NameReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setUsername(username):
            newState.username = username
            
        case let .setButtonEnabled(isEnabled):
            newState.isButtonEnabled = isEnabled
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
        }
        
        return newState
    }
    
}

extension NameReactor {
    
    private func isValidName(_ username: String) -> Bool {
        return username.count >= 1
    }
    
}
