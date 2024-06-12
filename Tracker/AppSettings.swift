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

enum IdentityCellEnum: String {

    case categoryViewCell = "categoryCell"
    case filterViewCell =  "filterViewCell"
    case schedulerTableViewCell = "schedulerCell"
    case createHabbitViewSettingsCell = "habbitCell"
    case trackerCollectionViewCell = "trackerCell"
    case emojiAndColorViewCell = "emojiAndColorCell"
    case statsViewCell =  "statsViewCell"
    case headerViewIdentifier =  "headerViewIdentifier"
}
