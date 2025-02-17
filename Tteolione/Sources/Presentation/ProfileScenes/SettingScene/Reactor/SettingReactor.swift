//
//  SettingReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import Foundation
import ReactorKit
import RxSwift

final class SettingReactor: Reactor {
    
    enum Action {
        case toggleNotification(Bool)
        case backButtonTap
    }
    
    enum Mutation {
        case updateNotificationState(Bool)
        case backButtonTapped(Bool)
    }
    
    struct State {
        var sections: [SettingSection] = []
        var isBackButtonTapped: Bool = false
    }
    
    var initialState = State()
    
    init() {
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
        }
        return newState
    }
    
}
