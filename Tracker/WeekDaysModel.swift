//
//  WeekDaysModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 03.04.2024.
//

import Foundation

enum WeekDaysModel: String {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Cр"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}

extension WeekDaysModel: Codable {

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
}
