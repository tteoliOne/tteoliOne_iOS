//
//  UserDefaultsStorage.swift
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
            if T.self is [String].Type {
                return UserDefaults.standard.stringArray(forKey: key) as? T ?? defaultValue
            }
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            if let array = newValue as? [String] {
                UserDefaults.standard.set(array, forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

enum UserDefaultsStorage {
    
    enum Keys: String, CaseIterable {
        case recentSearches
        case accessToken
        case refreshToken
        case fcmToken
        case userID
        case nickname
        case typeLogin
        case latitude
        case longitude
    }

    @UserDefault(key: Keys.recentSearches.rawValue, defaultValue: [])
    static var recentSearches: [String]
    
    @UserDefault(key: Keys.accessToken.rawValue, defaultValue: "")
    static var token: String

    @UserDefault(key: Keys.refreshToken.rawValue, defaultValue: "")
    static var refreshToken: String

    @UserDefault(key: Keys.fcmToken.rawValue, defaultValue: "")
    static var fcmToken: String
    
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

    static func addRecentSearch(_ query: String) {
        var searches = recentSearches
        searches.removeAll { $0 == query }
        searches.insert(query, at: 0)
        recentSearches = Array(searches.prefix(10))
    }
    
    static func removeRecentSearch(_ query: String) {
        var searches = recentSearches
        searches.removeAll { $0 == query }
        recentSearches = searches
    }
    
    static func clearRecentSearches() {
        recentSearches = []
    }
    
    static func remove(_ key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static func deleteAll() {
        Keys.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
