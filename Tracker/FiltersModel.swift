//
//  FiltersModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 12.06.2024.
//

import Foundation

enum FilterModel: String, Codable, CaseIterable {

    case all
    case today
    case complete
    case uncomplete

    var localizedString: String {
        switch self {
        case .all: return L10n.Localizable.FiltersModel.Case.all
        case .today: return L10n.Localizable.FiltersModel.Case.today
        case .complete: return L10n.Localizable.FiltersModel.Case.complete
        case .uncomplete: return L10n.Localizable.FiltersModel.Case.uncomplete
        }
    }

    static func fromIndex(_ index: Int) -> FilterModel? {
        switch index {
        case 0: return .all
        case 1: return .today
        case 2: return .complete
        case 3: return .uncomplete
        default: return nil
        }
    }

    static func fromRawValue(_ value: String) -> FilterModel? {
        return FilterModel.allCases.first { $0.rawValue == value }
    }
}

extension FilterModel {
    var index: Int {
        switch self {
        case .all:
            return 0
        case .today:
            return 1
        case .complete:
            return 2
        case .uncomplete:
            return 3
        }
    }
}
