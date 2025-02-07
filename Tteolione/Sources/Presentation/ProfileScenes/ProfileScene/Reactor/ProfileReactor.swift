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
        case myShareTap(StatusType)
    }
    
    enum Mutation {
        case setProfile(UserProfileDTO)
        case showError(NetworkError)
        case setFailureType(Bool)
        case myProductScreen(Bool, StatusType?)
    }
    
    struct State {
        var tableViewItems: [MenuItem] = []
        var profile: UserProfileDTO?
        var errorMessage: String?
        var isFailure: Bool = false
        var isMyProductScreen: Bool = false
        var selectedStatus: StatusType?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    let initialState: State
   
    init(networkProvider: NetworkProvider<UserAPI>) {
        let menuItems = [
            MenuItem(title: "내 공유글 목록"),
            MenuItem(title: "공유완료 목록"),
            MenuItem(title: "저장글 목록"),
            MenuItem(title: "후기 목록"),
            MenuItem(title: "프로필 수정")
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
            
        case .myShareTap(let status):
            return .concat([
                .just(.myProductScreen(true, status)),
                .just(.myProductScreen(false, nil))
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
            
        case let .myProductScreen(isScreen, status):
            newState.isMyProductScreen = isScreen
            newState.selectedStatus = status
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
