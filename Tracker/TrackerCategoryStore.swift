//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init() {
        self.context = CoreDataManager.shared.getContext()
    }

    // MARK: - Public Methods

    func createRecord(with title: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        CoreDataManager.shared.saveContext()
    }

    func getCategory(withName categoryName: String) throws -> TrackerCategoryCoreData {
       let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
       fetchRequest.predicate = NSPredicate(format: "title == %@", categoryName)

        let categories = try? context.fetch(fetchRequest)
        return categories?.first ?? TrackerCategoryCoreData()
   }

    func getAllTitle() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.propertiesToFetch = ["title"]

        do {
            let results = try context.fetch(fetchRequest)
            let titles = results.compactMap { $0.value(forKey: "title") as? String }
            return titles
        } catch {
            print("Error fetching titles: \(error)")
            return []
        }
    }

    func togglePinTracker(_ trackerId: UUID?) throws {

        guard let trackerId = trackerId else { return }

        let store = TrackerStore()

        guard let tracker = try store.getTracker(withId: trackerId) else {
            throw NSError(
                domain: "TrackerErrorDomain",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Tracker not found"]
            )
        }

        let pinnedCategory = try getCategory(withName: AppSettings.pinCategoryName)

        if tracker.category == pinnedCategory {
            if let originalCategoryName = tracker.beforePin {
                let originalCategory = try getCategory(withName: originalCategoryName)
                tracker.category = originalCategory
                tracker.beforePin = nil
            } else {
                throw NSError(
                    domain: "CategoryErrorDomain",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Original category not found"]
                )
            }
        } else {
            tracker.beforePin = tracker.category?.title
            tracker.category = pinnedCategory
        }

        try? context.save()
    }

    // MARK: - Private Methods

    private func addTracker(title: String, tracker: TrackerCoreData) {
        let trackerCategoryCoreData = try? getCategory(withName: title)
        trackerCategoryCoreData?.addToTrackers(tracker)
    }
}
