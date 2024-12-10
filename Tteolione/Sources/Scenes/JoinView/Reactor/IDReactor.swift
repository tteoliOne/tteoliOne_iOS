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
    }

    struct State {
        var id: String = ""
        var isButtonEnabled: Bool = false
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
}

extension IDReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .idInputChanged(id):
            let isValid = isValidID(id)
            
            return Observable.concat([
                Observable.just(.setID(id)),
                Observable.just(.setButtonEnabled(isValid))
            ])
            
        case .backButtonTap:
            backNavigation.onNext(())
            return Observable.empty()
            
        case .idCheckButtonTap:
            navigateToNextView.onNext(())
            return Observable.empty()
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
