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
        case .monday: return NSLocalizedString("weekDaysModel.case.monday", comment: "")
        case .tuesday: return NSLocalizedString("weekDaysModel.case.tuesday", comment: "")
        case .wednesday: return NSLocalizedString("weekDaysModel.case.wednesday", comment: "")
        case .thursday: return NSLocalizedString("weekDaysModel.case.thursday", comment: "")
        case .friday: return NSLocalizedString("weekDaysModel.case.friday", comment: "")
        case .saturday: return NSLocalizedString("weekDaysModel.case.saturday", comment: "")
        case .sunday: return NSLocalizedString("weekDaysModel.case.sunday", comment: "")
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
