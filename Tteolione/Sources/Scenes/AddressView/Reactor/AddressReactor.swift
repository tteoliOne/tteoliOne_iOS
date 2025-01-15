//
//  AddressReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import ReactorKit
import RxSwift

final class AddressReactor: Reactor {
    
    enum Action {

    }
    
    enum Mutation {

    }

    struct State {

    }
    
    let initialState: State = State()
    
}

extension AddressReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {

    }
    
}

extension AddressReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
//        switch mutation {
//        case let .setEmailLabelPosition(up):
//            newState.isEmailLabelUp = up
//            
//        case let .setPasswordLabelPosition(up):
//            newState.isPasswordLabelUp = up
//            
//        case .togglePasswordSecureMode:
//            newState.isPasswordSecure.toggle()
//            
//        case let .setSignUpToNext(isNavi):
//            newState.isSignUpToNext = isNavi
//            
//        case let .setFindIDToNext(isNavi):
//            newState.isFindIDToNext = isNavi
//        }
        
        return newState
    }
    
}
