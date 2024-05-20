//
//  UserDefaultsWrapper.swift
//  Tracker
//
//  Created by Artem Krasnov on 19.05.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper {

    private let key: String
    private let defaultValue: Bool
    private let userDefaults: UserDefaults

    init(key: String, defaultValue: Bool, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: Bool {
        get {
            if userDefaults.object(forKey: key) == nil {
                return defaultValue
            }
            return userDefaults.bool(forKey: key)
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
