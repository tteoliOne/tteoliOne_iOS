//
//  UserDefaultsManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

final class UserDefaultsManager {
    
    private enum UserDefaultsKey: String {
        case access
        case refresh
        case userID
    }
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    var token: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
    
    var userID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.userID.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.userID.rawValue)
        }
    }
    
}
