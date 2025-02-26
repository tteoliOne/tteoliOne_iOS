//
//  OpponentReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/16/25.
//

import Foundation
import ReactorKit
import RxSwift

final class OpponentReactor: Reactor {
    
    enum Action {
        case fetchOpponent
        case segmentChanged(Int)
        case fetchOpponentProduct(String)
        case backButtonTap
    }
    
    enum Mutation {
        case setOpponentProfile(OtherUserDTO)
        case setOpponentProducts([ProductPreviewDTO])
        case setOpponentReviews([MyReviewDTO])
        case showError(NetworkError)
        case setSelectedSegmentIndex(Int)
        case backButtonTapped(Bool)
    }
    
    struct State {
        var userId: Int = 0
        var otherUserDTO: OtherUserDTO?
        var opponentProducts: [ProductPreviewDTO] = []
        var otherReviewsDTO: [MyReviewDTO] = []
        var errorMessage: String?
        var selectedSegmentIndex: Int = 0
        var isBackButtonTapped: Bool = false
    }
    
    private let networkUserProvider: NetworkProvider<UserAPI>
    var initialState: State = State()
    
    init(networkUserProvider: NetworkProvider<UserAPI>,
         userId: Int) {
        self.networkUserProvider = networkUserProvider
        self.initialState = State(userId: userId,
                                  selectedSegmentIndex: 0)
    }
    
}

extension OpponentReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchOpponent:
            return .concat([
                fetchOpponent(currentState.userId),
                fetchOpponentProduct(currentState.userId,
                                     status: "eNew")
            ])
            
        case .segmentChanged(let index):
            let status = index == 0 ? "eNew" : (index == 1 ? "eSoldOut" : "")
            
            if index == 2 {
                return .concat([
                    .just(.setSelectedSegmentIndex(index)),
                    fetchOpponentReview(currentState.userId)
                ])
            }
            
            if status.isEmpty {
                return .concat([
                    .just(.setSelectedSegmentIndex(index)),
                    .just(.setOpponentProducts([]))
                ])
            } else {
                return .concat([
                    .just(.setSelectedSegmentIndex(index)),
                    fetchOpponentProduct(currentState.userId,
                                         status: status)
                ])
            }

        case .fetchOpponentProduct(let status):
            return fetchOpponentProduct(currentState.userId, status: status)
            
        case .backButtonTap:
            return .concat([
                .just(.backButtonTapped(true)),
                .just(.backButtonTapped(false))
            ])
        }
    }
    
}

extension OpponentReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setOpponentProfile(let dto):
            newState.otherUserDTO = dto
            
        case .setOpponentProducts(let products):
            newState.opponentProducts = products
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
            
        case .setSelectedSegmentIndex(let index):
            newState.selectedSegmentIndex = index
            
        case .setOpponentReviews(let review):
            newState.otherReviewsDTO = review
            
        case .backButtonTapped(let isBack):
            newState.isBackButtonTapped = isBack
        }
        
        return newState
    }
    
}

extension OpponentReactor {
    private func fetchOpponent(_ userId: Int) -> Observable<Mutation> {
        return networkUserProvider.request(.getOtherUserProfile(userId: userId),
                                       decodingType: ServerResponse<OtherUserDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .concat([
                    .just(.setOpponentProfile(dto))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchOpponentProduct(_ userId: Int,
                                      status: String) -> Observable<Mutation> {
        let longitude = UserDefaultsStorage.longitude
        let latitude = UserDefaultsStorage.latitude
        let query = ProductQueryParameters(longitude: longitude,
                                           latitude: latitude,
                                           page: 0,
                                           size: 5,
                                           soldStatus: status)
        return networkUserProvider.request(.getOtherUserProduct(userId: userId, query: query),
                                           decodingType: ServerResponse<ProductFilterListDTO>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .just(.setOpponentProducts(dto.content))
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchOpponentReview(_ userId: Int) -> Observable<Mutation> {
        return networkUserProvider.request(.getMyReview(userId: userId),
                                           decodingType: ServerResponse<[MyReviewDTO]>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return .just(.setOpponentReviews(dto))
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
