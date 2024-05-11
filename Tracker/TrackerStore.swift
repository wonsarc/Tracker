//
//  TrackerStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData
import UIKit

final class TrackerStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    convenience init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to retrieve Core Data context")
        }
        self.init(context: context)
    }

    // MARK: - Public Methods

    func addRecord(_ record: TrackerModel, toCategoryWithName categoryName: String) throws {

        let trackerCategory = try TrackerCategoryStore().getCategory(withName: categoryName)

        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = record.id
        trackerCoreData.name = record.name
        trackerCoreData.emoji = record.emoji
        trackerCoreData.color = record.color
        trackerCoreData.schedule = record.schedule as NSObject

        trackerCoreData.category = trackerCategory

        trackerCategory.addToTrackers(trackerCoreData)

        try context.save()
    }
}
