//
//  WithdrawReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import Foundation
import ReactorKit
import RxSwift

final class WithdrawReactor: Reactor {
    
    enum Action {
        case backButtonTap
        case withdrawButtonTap
        case withdrawCheckButtonTap
        case withdrawApple(String)
    }
    
    enum Mutation {
        case backButtonTapped(Bool)
        case withdrawButtonTapped(Bool)
        case withdrawCheckButtonTapped(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var isBackButtonTapped: Bool = false
        var isWithdrawButtonTapped: Bool = false
        var isWithdrawCheckButtonTapped: Bool = false
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    var initialState = State()
    
    init(networkProvider: NetworkProvider<UserAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension WithdrawReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .backButtonTap:
            return .concat([
                .just(.backButtonTapped(true)),
                .just(.backButtonTapped(false))
            ])
            
        case .withdrawButtonTap:
            return .concat([
                .just(.withdrawButtonTapped(true)),
                .just(.withdrawButtonTapped(false))
            ])
            
        case .withdrawCheckButtonTap:
            return withdraw()
            
        case .withdrawApple(let authCode):
            return withdraw(authorizationCode: authCode)
        }
    }
    
}

extension WithdrawReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .backButtonTapped(let isTap):
            newState.isBackButtonTapped = isTap
            
        case .withdrawButtonTapped(let isTap):
            newState.isWithdrawButtonTapped = isTap
            
        case .withdrawCheckButtonTapped(let isTap):
            newState.isWithdrawCheckButtonTapped = isTap
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
    
}

extension WithdrawReactor {
    private func withdraw(authorizationCode: String? = nil) -> Observable<Mutation> {
        let userId = UserDefaultsStorage.userID
        let body: WithdrawalRequestBody
        
        switch UserDefaultsStorage.typeLogin {
        case "apple":
            body = WithdrawalRequestBody(authorizationCode: authorizationCode)
        default:
            body = WithdrawalRequestBody(authorizationCode: nil)
        }
        
        return networkProvider
            .request(.withdrawal(userId: userId, body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
                    NotificationCenter.default.post(name: .logout, object: nil)
                    return .concat([
                        .just(.withdrawCheckButtonTapped(true)),
                        .just(.withdrawCheckButtonTapped(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}
