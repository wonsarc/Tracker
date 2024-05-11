//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {

    // MARK: - Private Properties

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "ANY trackers.schedule CONTAINS[c] %@",
            WeekDaysModel.friday.rawValue
        )

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: false)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "title",
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        try? fetchedResultsController.performFetch()

        return fetchedResultsController
    }()

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to retrieve Core Data context")
        }
        self.init(context: context)
    }

    // MARK: - Public Methods

    func addTracker(title: String, tracker: TrackerCoreData) {
        let trackerCategoryCoreData = try? getCategory(withName: title)
        trackerCategoryCoreData?.addToTrackers(tracker)
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

    func getAll(day: WeekDaysModel) -> [TrackerCategoryModel] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY trackers.schedule CONTAINS[c] %@", day.rawValue)

        do {
            let coreDataObjects = try context.fetch(fetchRequest)
            let trackerCategoryModels = coreDataObjects.map { coreDataObject in
                let trackerModels = extractTrackerModels(from: coreDataObject, for: day)
                return TrackerCategoryModel(
                    title: coreDataObject.title ?? "",
                    trackers: trackerModels
                )
            }
            return trackerCategoryModels
        } catch {
            print("Error fetching tracker categories: \(error)")
            return []
        }
    }

    private func extractTrackerModels(
        from coreDataObject: TrackerCategoryCoreData,
        for day: WeekDaysModel
    ) -> [TrackerModel] {
        guard let trackersSet = coreDataObject.trackers as? Set<TrackerCoreData> else {
            return []
        }

        let trackers = Array(trackersSet)
        let trackerModels = trackers.compactMap { tracker -> TrackerModel? in
            guard let id = tracker.id,
                  let name = tracker.name,
                  let emoji = tracker.emoji,
                  let schedule = tracker.schedule as? [WeekDaysModel],
                  let color = tracker.color as? UIColor,
                  schedule.contains(day) else {
                return nil
            }

            return TrackerModel(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: schedule
            )
        }

        return trackerModels
    }

    func getCategory(withName categoryName: String) throws -> TrackerCategoryCoreData {
        if let category = findCategory(by: categoryName) {
            return category
        } else {
            return getNewRecord(with: categoryName)
        }
    }

     private func findCategory(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            let categories = try context.fetch(fetchRequest)
            return categories.first
        } catch {
            return nil
        }
    }

    func getNewRecord(with title: String) -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        try? context.save()
        return trackerCategoryCoreData
    }

    func createRecord(with title: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        try? context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {

    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> TrackerCategoryModel? {
        let object = fetchedResultsController.object(at: indexPath)

        var trackerModels: [TrackerModel] = []
        if let trackers = object.trackers {
            for case let tracker as TrackerCoreData in trackers {

                guard let id = tracker.id,
                      let name = tracker.name,
                      let color = tracker.color as? UIColor,
                      let emoji = tracker.emoji,
                      let scedule = DaysValueTransformer()
                    .reverseTransformedValue(tracker.schedule) as? [WeekDaysModel] else {
                    fatalError("Cannot create TrackerModel without name, color, and emoji")
                }

                let trackerModel = TrackerModel(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: scedule
                )
                trackerModels.append(trackerModel)
            }
        }

        let trackerCategoryModel = TrackerCategoryModel(
            title: object.title!,
            trackers: trackerModels
        )

        return trackerCategoryModel
    }
}
