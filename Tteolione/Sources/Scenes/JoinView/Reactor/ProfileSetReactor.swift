//
//  ProfileSetReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation
import ReactorKit
import RxSwift

final class ProfileSetReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }

    struct State {
        
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
}

extension ProfileSetReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
}

extension ProfileSetReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        return newState
    }
    
}
