//
//  ProfileReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import UIKit
import ReactorKit
import RxSwift

final class ProfileReactor: Reactor {
    
    enum Action {
        case fetchProfile
        case resetProfileButtonTap
        case resetProfileListTap
        case myShareTap(StatusType)
        case updateNickname(String)
        case updateIntro(String)
        case photoButtonTap
        case imageSelected(UIImage)
        case gearButtonTap
    }
    
    enum Mutation {
        case setProfile(UserProfileDTO)
        case showError(NetworkError)
        case setFailureType(Bool)
        case setResetProfileListTapped(Bool)
        case myProductScreen(Bool, StatusType?)
        case setNickname(String)
        case setIntro(String)
        case setIntroLengthText(String)
        case setProfileImagePicker(Bool)
        case setProfileImage(UIImage?)
        case setGearButtonTapped(Bool)
    }
    
    struct State {
        var tableViewItems: [MenuItem] = []
        var profile: UserProfileDTO?
        var errorMessage: String?
        var isFailure: Bool = false
        var isMyProductScreen: Bool = false
        var isResetProfileListTapped: Bool = false
        var selectedStatus: StatusType?
        var nickname: String = ""
        var intro: String = ""
        var introLengthText: String = "0/20"
        var isProductImagePickerShown: Bool = false
        var profileImage: UIImage?
        var isGearButtonTapped: Bool = false
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
            return fetchUpdateProfile(nickname: currentState.nickname,
                                      intro: currentState.intro,
                                      profileImage: currentState.profileImage ?? nil)
            
        case .myShareTap(let status):
            return .concat([
                .just(.myProductScreen(true, status)),
                .just(.myProductScreen(false, nil))
            ])
            
        case .resetProfileListTap:
            return .concat([
                .just(.setResetProfileListTapped(true)),
                .just(.setResetProfileListTapped(false))
            ])
            
        case .updateNickname(let nickname):
            return .concat([
                .just(.setNickname(nickname))
            ])
            
        case .updateIntro(let intro):
            let maxLength = 20
            let trimmedIntro = String(intro.prefix(maxLength))
            let introLengthText = "\(trimmedIntro.count)/\(maxLength)"
            
            return .concat([
                .just(.setIntro(trimmedIntro)),
                .just(.setIntroLengthText(introLengthText))
            ])
            
        case .photoButtonTap:
            return .concat([
                .just(.setProfileImagePicker(true)),
                .just(.setProfileImagePicker(false))
            ])
            
        case .imageSelected(let image):
            return .just(.setProfileImage(image))
            
        case .gearButtonTap:
            return .concat([
                .just(.setGearButtonTapped(true)),
                .just(.setGearButtonTapped(false))
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
            
        case .setResetProfileListTapped(let isTap):
            newState.isResetProfileListTapped = isTap
            
        case .setNickname(let nickname):
            newState.nickname = nickname
            
        case .setIntro(let intro):
            newState.intro = intro
            
        case .setIntroLengthText(let length):
            newState.introLengthText = length
            
        case .setProfileImagePicker(let isPicker):
            newState.isProductImagePickerShown = isPicker
            
        case .setProfileImage(let image):
            newState.profileImage = image
            
        case .setGearButtonTapped(let isGear):
            newState.isGearButtonTapped = isGear
        }
        
        return newState
    }
    
}

extension ProfileReactor {
    
    private func fetchProductsPost() -> Observable<Mutation> {
        return networkProvider.request(.getMyProfile,
                                       decodingType: ServerResponse<UserProfileDTO>.self)
        .asObservable()
        .flatMapLatest { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(let dto):
                return Observable.concat([
                    .just(.setProfile(dto)),
                    .just(.setNickname(dto.nickname)),
                    .just(.setIntro(dto.intro ?? "")),
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
        let requestBody = UserProfileRequestBody(nickname: nickname,
                                                 intro: intro)
        let profileImageData = profileImage?.jpegData(compressionQuality: 0.8) ?? Data()
        let body = UpdateMyProfileRequestBody(userProfileRequest: requestBody,
                                              image: profileImageData)
        return networkProvider.request(.updateMyProfile(body: body),
                                       decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
                    .just(.setNickname(nickname)),
                    .just(.setIntro(intro)),
                    .just(.setProfileImage(profileImage)),
                    .just(.setFailureType(true)),
                    .just(.setFailureType(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
