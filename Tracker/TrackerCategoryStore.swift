//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

final class TrackerCategoryStore {

    let coreDataManager = CoreDataManager.shared

    func addTrackerCategory(name: String) {
        let context = coreDataManager.getContext()

        let trackerCategory = TrackerCategoryData(context: context)
        trackerCategory.title = "123"
        coreDataManager.saveContext()
    }
}
