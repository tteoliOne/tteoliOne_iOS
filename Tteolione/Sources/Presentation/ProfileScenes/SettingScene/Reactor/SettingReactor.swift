//
//  SettingReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit

final class SettingReactor: Reactor {
    
    enum Action {
        case toggleNotification(Bool)
        case backButtonTap
        case profileSettingTap
        case profileResetPasswordTap
        case resetAddressTap
        case logoutTap
        case logoutCheckTap
        case withDrawTap
    }
    
    enum Mutation {
        case updateNotificationState(Bool)
        case backButtonTapped(Bool)
        case profileSettingTapped(Bool)
        case profileResetPasswordTapped(Bool)
        case resetAddressTapped(Bool)
        case logoutTapped(Bool)
        case logoutCheckTapped(Bool)
        case withDrawTapped(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var sections: [SettingSection] = []
        var isBackButtonTapped: Bool = false
        var isProfileSettingTapped: Bool = false
        var isProfileResetPasswordTapped: Bool = false
        var isResetAddressTapped: Bool = false
        var isLogoutTapped: Bool = false
        var isLogoutCheckTapped: Bool = false
        var isWithDrawTapped: Bool = false
        var errorMessage: String?
    }
    
    private let userSessionNetworkProvider: NetworkProvider<UserSessionAPI>
    var initialState = State()
    
    init(networkProvider: NetworkProvider<UserSessionAPI>) {
        self.userSessionNetworkProvider = networkProvider
        let sections = [
            SettingSection(title: "계정", items: [.profile, .password, .address]),
            SettingSection(title: "알림", items: [.chatNotification(true)]),
            SettingSection(title: "정보", items: [
                .terms, .privacy, .version("1.0.0"), .logout, .withdraw
            ])
        ]
        self.initialState = State(sections: sections)
    }
}

extension SettingReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleNotification(let isOn):
            return .just(.updateNotificationState(isOn))
            
        case .backButtonTap:
            return .concat([
                .just(.backButtonTapped(true)),
                .just(.backButtonTapped(false))
            ])
            
        case .profileSettingTap:
            return .concat([
                .just(.profileSettingTapped(true)),
                .just(.profileSettingTapped(false))
            ])
            
        case .profileResetPasswordTap:
            return .concat([
                .just(.profileResetPasswordTapped(true)),
                .just(.profileResetPasswordTapped(false))
            ])
            
        case .resetAddressTap:
            return .concat([
                .just(.resetAddressTapped(true)),
                .just(.resetAddressTapped(false))
            ])
            
        case .logoutTap:
            return .concat([
                .just(.logoutTapped(true)),
                .just(.logoutTapped(false))
            ])
            
        case .logoutCheckTap:
            return logout()
            
        case .withDrawTap:
            return .concat([
                .just(.withDrawTapped(true)),
                .just(.withDrawTapped(false))
            ])
        }
    }
    
}

extension SettingReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateNotificationState(let isOn):
            if let index = newState.sections.firstIndex(where: { $0.title == "알림" }) {
                newState.sections[index].items = [.chatNotification(isOn)]
            }
            
        case .backButtonTapped(let isTap):
            newState.isBackButtonTapped = isTap
            
        case .profileSettingTapped(let isTap):
            newState.isProfileSettingTapped = isTap
            
        case .profileResetPasswordTapped(let isTap):
            newState.isProfileResetPasswordTapped = isTap
            
        case .resetAddressTapped(let isTap):
            newState.isResetAddressTapped = isTap
            
        case .logoutTapped(let isTap):
            newState.isLogoutTapped = isTap
            
        case .logoutCheckTapped(let isTap):
            newState.isLogoutCheckTapped = isTap
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .withDrawTapped(let isTap):
            newState.isWithDrawTapped = isTap
        }
        
        return newState
    }
    
}

extension SettingReactor {
    private func logout() -> Observable<Mutation> {
        return userSessionNetworkProvider
            .request(.logout,
                     decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
                    NotificationCenter.default.post(name: .logout, object: nil)
                    return .concat([
                        .just(.logoutCheckTapped(true)),
                        .just(.logoutCheckTapped(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
}
