//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.04.2024.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}

    var category: [TrackerCategoryModel] = []
    var completedTrackers: [TrackerRecordModel] = []
    var selectCategoryItem: IndexPath = IndexPath()
}
