//
//  ProductDetailReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/11/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ProductDetailReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }

    struct State {
        
    }
    
    let initialState: State = State()
    
}

extension ProductDetailReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
}

extension ProductDetailReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        return newState
    }
    
}
