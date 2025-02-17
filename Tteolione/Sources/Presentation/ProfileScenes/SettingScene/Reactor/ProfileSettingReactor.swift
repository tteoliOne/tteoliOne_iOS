//
//  ProfileSettingReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import UIKit
import ReactorKit
import RxSwift

final class ProfileSettingReactor: Reactor {
    
    enum Action {
        case fetchProfile
        case photoButtonTap
        case imageSelected(UIImage)
        case updateNickname(String)
        case updateIntro(String)
        case resetProfileButtonTap
        case backButtonTap
    }
    
    enum Mutation {
        case showError(NetworkError)
        case clearErrorMessage
        case setProfileImagePicker(Bool)
        case setProfileImage(UIImage?)
        case setNickname(String)
        case setIntro(String)
        case setIntroLengthText(String)
        case backButtonTapped(Bool)
    }
    
    struct State {
        var errorMessage: String?
        var isProductImagePickerShown: Bool = false
        var profileImage: UIImage?
        var nickname: String = ""
        var intro: String = ""
        var introLengthText: String = "0/20"
        var backButtonTapped: Bool = false
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    let initialState = State()
    
    init(networkProvider: NetworkProvider<UserAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension ProfileSettingReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProfile:
            return fetchProductsPost()
            
        case .photoButtonTap:
            return .concat([
                .just(.setProfileImagePicker(true)),
                .just(.setProfileImagePicker(false))
            ])
            
        case .imageSelected(let image):
            return .just(.setProfileImage(image))
            
        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))
            
        case .updateIntro(let intro):
            let maxLength = 20
            let trimmedIntro = String(intro.prefix(maxLength))
            let introLengthText = "\(trimmedIntro.count)/\(maxLength)"
            
            return .concat([
                .just(.setIntro(trimmedIntro)),
                .just(.setIntroLengthText(introLengthText))
            ])
            
        case .resetProfileButtonTap:
            return fetchUpdateProfile(nickname: currentState.nickname,
                                      intro: currentState.intro,
                                      profileImage: currentState.profileImage)
            
        case .backButtonTap:
            return .concat([
                .just(.backButtonTapped(true)),
                .just(.backButtonTapped(false))
            ])
        }
    }
    
}

extension ProfileSettingReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .clearErrorMessage:
            newState.errorMessage = nil
            
        case .setProfileImagePicker(let isPicker):
            newState.isProductImagePickerShown = isPicker
            
        case .setProfileImage(let image):
            newState.profileImage = image
            
        case .setNickname(let nickname):
            newState.nickname = nickname
            
        case .setIntro(let intro):
            newState.intro = intro
            
        case .setIntroLengthText(let length):
            newState.introLengthText = length
            
        case .backButtonTapped(let isTap):
            newState.backButtonTapped = isTap
        }
        
        return newState
    }
    
}

extension ProfileSettingReactor {
    private func fetchProductsPost() -> Observable<Mutation> {
        return networkProvider.request(.getMyProfile,
                                       decodingType: ServerResponse<UserProfileDTO>.self)
        .asObservable()
        .flatMapLatest { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                let introText = dto.intro ?? ""
                let maxLength = 20
                let introLengthText = "\(introText.count)/\(maxLength)"
                return .concat([
                    .just(.setNickname(dto.nickname)),
                    .just(.setIntro(dto.intro ?? "")),
                    .just(.setIntroLengthText(introLengthText)),
                    .create { observer in
                        Task {
                            if let profileUrl = URL(string: dto.profile),
                               let image = await UIImage.load(from: profileUrl) {
                                await MainActor.run {
                                    observer.onNext(.setProfileImage(image))
                                }
                            } else {
                                await MainActor.run {
                                    observer.onNext(.setProfileImage(nil))
                                }
                            }
                            observer.onCompleted()
                        }
                        return Disposables.create()
                    }
                ])

            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
    
    private func fetchUpdateProfile(nickname: String,
                                    intro: String,
                                    profileImage: UIImage?) -> Observable<Mutation> {
        let requestBody = UserProfileRequestBody(nickname: nickname, intro: intro)
        let profileImageData = profileImage?.jpegData(compressionQuality: 0.8) ?? Data()
        let body = UpdateMyProfileRequestBody(userProfileRequest: requestBody, image: profileImageData)
        
        return .concat([
            .just(.clearErrorMessage),
            networkProvider
                .request(.updateMyProfile(body: body), decodingType: ServerResponse<String>.self)
                .asObservable()
                .catch { error in
                    if let networkError = error as? NetworkError {
                        return .just(ServerResponse<String>(success: false, code: -1, message: networkError.errorDescription, data: nil))
                    }
                    return .just(ServerResponse<String>(success: false, code: -1, message: "알 수 없는 오류", data: nil))
                }
                .flatMap { response -> Observable<Mutation> in
                    switch handleResponse(response) {
                    case .success(_):
                        UserDefaultsStorage.nickname = self.currentState.nickname
                        return .concat([
                            .just(.backButtonTapped(true)),
                            .just(.backButtonTapped(false))
                        ])
                    case .failure(let error):
                        return .just(.showError(error))
                    }
                }
        ])
    }

}
