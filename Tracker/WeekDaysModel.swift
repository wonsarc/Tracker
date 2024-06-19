//
//  WeekDaysModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 03.04.2024.
//

import Foundation

enum WeekDaysModel: String, Codable, CaseIterable {

    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var localizedString: String {
        switch self {
        case .monday: return L10n.Localizable.WeekDaysModel.Case.monday
        case .tuesday: return L10n.Localizable.WeekDaysModel.Case.tuesday
        case .wednesday: return L10n.Localizable.WeekDaysModel.Case.wednesday
        case .thursday: return L10n.Localizable.WeekDaysModel.Case.thursday
        case .friday: return L10n.Localizable.WeekDaysModel.Case.friday
        case .saturday: return L10n.Localizable.WeekDaysModel.Case.saturday
        case .sunday: return L10n.Localizable.WeekDaysModel.Case.sunday
        }
    }

    static func fromIndex(_ index: Int) -> WeekDaysModel? {
        switch index {
        case 0: return .monday
        case 1: return .tuesday
        case 2: return .wednesday
        case 3: return .thursday
        case 4: return .friday
        case 5: return .saturday
        case 6: return .sunday
        default: return nil
        }
    }

    static func fromRawValue(_ value: String) -> WeekDaysModel? {
        return WeekDaysModel.allCases.first { $0.rawValue == value }
    }
}
