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
        case nickname
        case typeLogin
        case latitude
        case longitude
    }
    
    enum LoginTypeKey: String {
        case kakao
        case apple
        case local
    }
    
    static let shared = UserDefaultsManager()
    
    init() { }
    
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
    
    var userID: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKey.userID.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.userID.rawValue)
        }
    }
    
    var nickname: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.nickname.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.nickname.rawValue)
        }
    }
    
    var typeLogin: LoginTypeKey {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKey.typeLogin.rawValue),
               let loginType = LoginTypeKey(rawValue: rawValue) {
                return loginType
            }
            return .local
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKey.typeLogin.rawValue)
        }
    }
    
    var latitude: Double {
        get {
            UserDefaults.standard.double(forKey: UserDefaultsKey.latitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.latitude.rawValue)
        }
    }
    
    var longitude: Double {
        get {
            UserDefaults.standard.double(forKey: UserDefaultsKey.longitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.longitude.rawValue)
        }
    }
    
    func clearAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
