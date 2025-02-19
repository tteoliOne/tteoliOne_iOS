//
//  MyReviewReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import Foundation
import ReactorKit
import RxSwift

final class MyReviewReactor: Reactor {
    
    enum Action {
        case fetchReview
        case backButtonTap
    }
    
    enum Mutation {
        case setReview([MyReviewDTO])
        case showError(NetworkError)
        case isBackButtonTapped(Bool)
    }
    
    struct State {
        var reviewDTO: [MyReviewDTO]?
        var errorMessage: String?
        var isBackButtonTapped: Bool = false
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension MyReviewReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReview:
            return fetchUserReview()
            
        case .backButtonTap:
            return .concat([
                .just(.isBackButtonTapped(true)),
                .just(.isBackButtonTapped(false))
            ])
        }
    }
    
}

extension MyReviewReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReview(let dto):
            newState.reviewDTO = dto
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .isBackButtonTapped(let isBack):
            newState.isBackButtonTapped = isBack
        }
        
        return newState
    }
    
}

extension MyReviewReactor {
    private func fetchUserReview() -> Observable<Mutation> {
        let userID = UserDefaultsStorage.userID
        return networkProvider.request(.getMyReview(userId: userID),
                                       decodingType: ServerResponse<[MyReviewDTO]>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setReview(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
