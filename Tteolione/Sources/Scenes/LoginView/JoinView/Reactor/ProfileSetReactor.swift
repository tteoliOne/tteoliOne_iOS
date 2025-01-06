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
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
        case showError(NetworkError)
    }

    struct State {
        var profileImage: UIImage? = nil
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: OnBoardingMediator
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<JoinAPI>,
         mediator: OnBoardingMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension ProfileSetReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case let .imageSelected(image):
            return Observable.concat([
                .just(.setProfileImage(image))
            ])
            
        case .joinButtonTap:
            guard let profileImage = currentState.profileImage else {
                return .just(.showError(NetworkError.invalidInputImage))
            }
            return performSetImageProfile(profile: profileImage)
        }
    }
}

extension ProfileSetReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setProfileImage(image):
            newState.profileImage = image
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
        }
        
        return newState
    }
}

extension ProfileSetReactor {
    
    private func performSetImageProfile(profile: UIImage) -> Observable<Mutation> {
        
        let email = mediator.get(\OnBoardingReactor.State.email)
        let username = mediator.get(\OnBoardingReactor.State.username)
        let loginId = mediator.get(\OnBoardingReactor.State.loginId)
        let nickname = mediator.get(\OnBoardingReactor.State.nickname)
        let password = mediator.get(\OnBoardingReactor.State.password)
        
        guard let profileImageData = profile.jpegData(compressionQuality: 0.8) else {
            return .just(.showError(NetworkError.invalidInputImage))
        }
        
        let signUpRequest = JoinRequestBody(
            email: email,
            username: username,
            loginId: loginId,
            nickname: nickname,
            password: password
        )

        let body = SignUpProfileImageRequestBody(
            signUpRequest: signUpRequest,
            image: profileImageData
        )
        
        return networkProvider
            .request(.signUp(body: body), decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let message):
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}
