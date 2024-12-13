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
    }

    struct State {
        var nickname: String = ""
        var isButtonEnabled: Bool = false
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
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
            backNavigation.onNext(())
            return Observable.empty()
            
        case .nicknameCheckButtonTap:
            navigateToNextView.onNext(())
            return Observable.empty()
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
        }
        
        return newState
    }
    
}

extension NicknameReactor {
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let idRegex = "^[a-zA-Z가-힣0-9]{2,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return predicate.evaluate(with: nickname)
    }
    
}
