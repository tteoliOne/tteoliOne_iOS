//
//  ReviewPopReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ReviewPopReactor: Reactor {
    
    enum Action {
        case updateDescriptionText(String)
        case chevronUpTap
        case chevronDownTap
        case submitTap
        case backgroundTap
    }
    
    enum Mutation {
        case setDescriptionText(String)
        case setDescriptionLengthText(String)
        case setButtonEnabled(Bool)
        case setScore(Int)
        case submitTapped(Bool)
        case showError(NetworkError)
        case backgroundTapped(Bool)
    }
    
    struct State {
        var productId: Int?
        var descriptionText: String = ""
        var lengthText: String = "0/80"
        var isButtonEnabled: Bool = false
        var isSubmitTapped: Bool = false
        var score: Int = 1
        var errorMessage: String?
        var isBackgroundTapped: Bool = false
    }
    
    var initialState: State = State()
    private let networkChatProvider: NetworkProvider<ChatAPI>
    
    init(networkChatProvider: NetworkProvider<ChatAPI>,
         productId: Int) {
        self.networkChatProvider = networkChatProvider
        self.initialState = State(productId: productId)
    }
}

extension ReviewPopReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateDescriptionText(let text):
            let isValid = isValid(text)
            let maxLength = 80
            let trimmedText = String(text.prefix(maxLength))
            let textLengthText = "\(trimmedText.count)/\(maxLength)"
            return .concat([
                .just(.setDescriptionText(trimmedText)),
                .just(.setDescriptionLengthText(textLengthText)),
                .just(.setButtonEnabled(isValid))
            ])
            
        case .chevronUpTap:
            let newScore = min(currentState.score + 1, 5)
            return .just(.setScore(newScore))
            
        case .chevronDownTap:
            let newScore = max(currentState.score - 1, 1)
            return .just(.setScore(newScore))
            
        case .submitTap:
            return postReview(productId: currentState.productId ?? 0,
                              content: currentState.descriptionText,
                              ddabong: currentState.score)
            
        case .backgroundTap:
            return .concat([
                .just(.backgroundTapped(true)),
                .just(.backgroundTapped(false))
            ])
        }
    }
    
}

extension ReviewPopReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setDescriptionText(let text):
            newState.descriptionText = text
            
        case .setDescriptionLengthText(let length):
            newState.lengthText = length
            
        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
            
        case .submitTapped(let isTap):
            newState.isSubmitTapped = isTap
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .setScore(let newScore):
            newState.score = newScore
            
        case .backgroundTapped(let isTap):
            newState.isBackgroundTapped = isTap
        }
        
        return newState
    }
    
}

extension ReviewPopReactor {
    private func postReview(productId: Int,
                            content: String,
                            ddabong: Int) -> Observable<Mutation> {
        let body = SubmitReviewRequestBody(content: content,
                                           ddabong: ddabong)
        return networkChatProvider.request(.submitShareReview(productId: productId,
                                                              body: body),
                                           decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                NotificationCenter.default.post(name: .didCompleteReview,
                                                object: nil,
                                                userInfo: nil)
                return .concat([
                    .just(.submitTapped(true)),
                    .just(.submitTapped(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}

extension ReviewPopReactor {
    private func isValid(_ text: String) -> Bool {
        return text.count >= 1
    }
}
