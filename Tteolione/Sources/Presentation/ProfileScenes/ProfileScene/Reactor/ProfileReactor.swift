//
//  ProfileReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ProfileReactor: Reactor {
    
    enum Action {
        case fetchProfile
        case resetProfileButtonTap
    }
    
    enum Mutation {
        case setProfile(UserProfileDTO)
        case showError(NetworkError)
        case setFailureType(Bool)
    }
    
    struct State {
        var tableViewItems: [ProfileMenuItem] = []
        var profile: UserProfileDTO?
        var errorMessage: String?
        var isFailure: Bool = false
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    let initialState: State
   
    init(networkProvider: NetworkProvider<UserAPI>) {
        let menuItems = [
            ProfileMenuItem(title: "내 공유글 목록"),
            ProfileMenuItem(title: "공유완료 목록"),
            ProfileMenuItem(title: "저장글 목록"),
            ProfileMenuItem(title: "후기 목록"),
            ProfileMenuItem(title: "프로필 수정")
        ]
        self.initialState = State(tableViewItems: menuItems)
        self.networkProvider = networkProvider
    }
    
}

extension ProfileReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProfile:
            return .concat([
                fetchProductsPost()
            ])
            
        case .resetProfileButtonTap:
            return .concat([
                .just(.setFailureType(true)),
                .just(.setFailureType(false))
            ])
        }
    }
    
}

extension ProfileReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProfile(let data):
            newState.profile = data
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .setFailureType(let isFail):
            newState.isFailure = isFail
        }
        
        return newState
    }
    
}

extension ProfileReactor {
    
    private func fetchProductsPost() -> Observable<Mutation> {
        return networkProvider.request(.getMyProfile,
                                       decodingType: ServerResponse<UserProfileDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setProfile(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
}
