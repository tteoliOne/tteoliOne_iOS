//
//  IDReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/10/24.
//

import Foundation
import ReactorKit
import RxSwift

final class IDReactor: Reactor {
    
    enum Action {
        case idInputChanged(String)
        case backButtonTap
        case idCheckButtonTap
    }
    
    enum Mutation {
        case setID(String)
        case setButtonEnabled(Bool)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }

    struct State {
        var id: String = ""
        var isButtonEnabled: Bool = false
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
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

extension IDReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .idInputChanged(id):
            let isValid = isValidID(id)
            
            return .concat([
                .just(.setID(id)),
                .just(.setButtonEnabled(isValid))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .idCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            let id = currentState.id
            return .concat([
                performIDCheck(id: id)
            ])
        }
    }
    
}

extension IDReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setID(id):
            newState.id = id
            
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

extension IDReactor {
    
    private func isValidID(_ id: String) -> Bool {
        let idRegex = "^(?=.*[a-z])[a-zA-Z0-9]{6,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return predicate.evaluate(with: id)
    }
    
}

extension IDReactor {
    
    private func performIDCheck(id: String) -> Observable<Mutation> {
        let body = JoinRequestBody(loginId: id)
        return networkProvider
            .request(.validateID(body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let message):
                    self.mediator.update(id, action: OnBoardingReactor.Action.updateID)
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
