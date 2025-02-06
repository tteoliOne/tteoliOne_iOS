//
//  ReportReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ReportReactor: Reactor {
    
    enum Action {
        case checkButtonTap
    }
    
    enum Mutation {
        case checkButtonTapped(Bool)
    }
    
    struct State {
        var isCheckButtonTapped: Bool = false
    }
    
    let initialState: State = State()
    
}

extension ReportReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkButtonTap:
            return .concat([
                .just(.checkButtonTapped(true)),
                .just(.checkButtonTapped(false))
            ])
        }
    }
    
}

extension ReportReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
            
        case .checkButtonTapped(let isCheck):
            newState.isCheckButtonTapped = isCheck
        }
        
        return newState
    }
    
}
