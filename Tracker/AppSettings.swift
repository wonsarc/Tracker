//
//  AppSettings.swift
//  Tracker
//
//  Created by Artem Krasnov on 19.05.2024.
//

import Foundation

class AppSettings {
    @UserDefaultsWrapper(key: "isFirstOpen", defaultValue: true)
    static var isFirstOpen: Bool
}
