//
//  NicknameReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation
import ReactorKit
import RxSwift

final class NicknameReactor: Reactor {
    
    enum Action {
        case nicknameInputChanged(String)
        case backButtonTap
        case nicknameCheckButtonTap
    }
    
    enum Mutation {
        case setNickname(String)
        case setButtonEnabled(Bool)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }

    struct State {
        var nickname: String = ""
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

extension NicknameReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .nicknameInputChanged(Nickname):
            let isValid = isValidNickname(Nickname)
            
            return Observable.concat([
                Observable.just(.setNickname(Nickname)),
                Observable.just(.setButtonEnabled(isValid))
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .nicknameCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            let nickname = currentState.nickname
            return .concat([
                performNicknameCheck(nickname: nickname)
            ])
        }
    }
    
}

extension NicknameReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNickname(nickname):
            newState.nickname = nickname
            
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

extension NicknameReactor {
    
    private func performNicknameCheck(nickname: String) -> Observable<Mutation> {
        let body = JoinRequestBody(nickname: nickname)
        return networkProvider
            .request(.validateNickname(body: body),
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let message):
                    self.mediator.update(nickname,
                                         action: SignUpReactor.Action.updateNickname)
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

extension NicknameReactor {
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let idRegex = "^[a-zA-Z가-힣0-9]{2,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return predicate.evaluate(with: nickname)
    }
    
}
