//
//  FindIDResultReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import Foundation
import ReactorKit
import RxSwift

final class FindIDResultReactor: Reactor {
    
    enum Action {
        case resetPasswordButtonTap
        case LoginHomeButtonTap
    }
    
    enum Mutation {
        case setNavigateToNext(Bool)
        case setNavigateToLogin(Bool)
    }
    
    struct State {
        var resultID: String = ""
        var navigateToNext: Bool = false
        var navigateToLogin: Bool = false
    }
    
    private let networkProvider: NetworkProvider<FindAccountAPI>
    private let mediator: OnBoardingMediator
    var initialState = State()
    
    init(networkProvider: NetworkProvider<FindAccountAPI>,
         mediator: OnBoardingMediator,
         dto: FindIDDTO) {
        self.networkProvider = networkProvider
        self.mediator = mediator
        self.initialState = State(resultID: dto.loginId)
    }
    
}

extension FindIDResultReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .resetPasswordButtonTap:
            return .concat([
                .just(.setNavigateToNext(true)),
                .just(.setNavigateToNext(false))
            ])
            
        case .LoginHomeButtonTap:
            return .concat([
                .just(.setNavigateToLogin(true)),
                .just(.setNavigateToLogin(false))
            ])
        }
    }
    
}

extension FindIDResultReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateToLogin(navigateToLogin):
            newState.navigateToLogin = navigateToLogin
        }
        
        return newState
    }
    
}
