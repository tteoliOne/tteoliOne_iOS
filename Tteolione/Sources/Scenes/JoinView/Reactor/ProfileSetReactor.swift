//
//  ProfileSetReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import RxSwift
import ReactorKit

final class ProfileSetReactor: Reactor {
    
    enum Action {
        case backButtonTap
        case imageSelected(UIImage)
        case joinButtonTap
    }
    
    enum Mutation {
        case setProfileImage(UIImage)
    }

    struct State {
        var profileImage: UIImage? = nil
    }
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
}

extension ProfileSetReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTap:
            backNavigation.onNext(())
            return Observable.empty()
            
        case let .imageSelected(image):
            return Observable.concat([
                .just(.setProfileImage(image))
            ])
            
        case .joinButtonTap:
            navigateToNextView.onNext(())
            return Observable.empty()
        }
    }
}

extension ProfileSetReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setProfileImage(image):
            newState.profileImage = image
        }
        
        return newState
    }
}
