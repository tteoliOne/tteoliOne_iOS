//
//  SettingSection.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import RxDataSources

enum SettingItem: IdentifiableType, Equatable {
    case profile
    case password
    case address
    case chatNotification(Bool)
    case terms
    case privacy
    case version(String)
    case logout
    case withdraw
    
    var title: String {
        switch self {
        case .profile: return "프로필 설정"
        case .password: return "비밀번호 변경"
        case .address: return "주소 설정"
        case .chatNotification: return "채팅 알림"
        case .terms: return "이용약관"
        case .privacy: return "개인정보 처리방침"
        case .version: return "현재 버전"
        case .logout: return "로그아웃"
        case .withdraw: return "회원 탈퇴"
        }
    }
    
    var identity: String {
        switch self {
        case .chatNotification(let state):
            return "chatNotification_\(state)"
        case .version(let version):
            return "version_\(version)"
        default:
            return title
        }
    }
}

struct SettingSection: AnimatableSectionModelType {
    let title: String
    var items: [SettingItem]

    var identity: String { title }

    init(title: String, items: [SettingItem]) {
        self.title = title
        self.items = items
    }

    init(original: SettingSection, items: [SettingItem]) {
        self = original
        self.items = items
    }
}
