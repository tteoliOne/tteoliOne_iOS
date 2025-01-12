//
//  TabBase.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

enum TabBase: Int, CaseIterable {
    case main, chat, myProfile
    
    var tabTitle: String {
        switch self {
        case .main: return "홈"
        case .chat: return "채팅"
        case .myProfile: return "내 정보"
        }
    }
    
    var unselectedImage: UIImage? {
        switch self {
        case .main: return UIImage(systemName: "house")
        case .chat: return UIImage(systemName: "message")
        case .myProfile: return UIImage(systemName: "person")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .main: return UIImage(systemName: "house.fill")
        case .chat: return UIImage(systemName: "message.fill")
        case .myProfile: return UIImage(systemName: "person.fill")
        }
    }
}
