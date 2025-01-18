//
//  UserDefaultsManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsStorage {
    
    enum Keys: String, CaseIterable {
        case accessToken
        case refreshToken
        case userID
        case nickname
        case typeLogin
        case latitude
        case longitude
    }

    @UserDefault(key: Keys.accessToken.rawValue, defaultValue: "")
    static var token: String

    @UserDefault(key: Keys.refreshToken.rawValue, defaultValue: "")
    static var refreshToken: String

    @UserDefault(key: Keys.userID.rawValue, defaultValue: 0)
    static var userID: Int

    @UserDefault(key: Keys.nickname.rawValue, defaultValue: "")
    static var nickname: String

    @UserDefault(key: Keys.typeLogin.rawValue, defaultValue: LoginTypeKey.local.rawValue)
    static var typeLogin: String

    @UserDefault(key: Keys.latitude.rawValue, defaultValue: 0.0)
    static var latitude: Double

    @UserDefault(key: Keys.longitude.rawValue, defaultValue: 0.0)
    static var longitude: Double

    static func deleteAll() {
        Keys.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
