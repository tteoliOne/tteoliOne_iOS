//
//  MapReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MapReactor: Reactor {
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState: State = State()
    
}

extension MapReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        
//        return .empty()
    }
    
}

extension MapReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
    
        
//        return newState
    }
    
}
