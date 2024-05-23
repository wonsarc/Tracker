//
//  TrackerStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerStore: NSObject {

    weak var delegate: TrackerStoreDelegate?

    var day: WeekDaysModel? {
        didSet {
            refreshFetchResults()
        }
    }

    var searchName: String? {
        didSet {
            refreshFetchResults()
        }
    }

    var frcStore: NSFetchedResultsController<TrackerCoreData>?

    // MARK: - Private Properties

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    override init() {
        self.context = CoreDataManager.shared.getContext()
    }

    // MARK: - Public Methods

    func addRecord(_ record: TrackerModel, toCategoryWithName categoryName: String) throws {

        let trackerCategory = try TrackerCategoryStore().getCategory(withName: categoryName)

        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = record.id
        trackerCoreData.name = record.name
        trackerCoreData.emoji = record.emoji
        trackerCoreData.color = record.color
        trackerCoreData.schedule = record.schedule as NSArray
        trackerCoreData.category = trackerCategory

        trackerCategory.addToTrackers(trackerCoreData)
        CoreDataManager.shared.saveContext()
    }

    private func castInTrackerModel(for object: TrackerCoreData) -> TrackerModel? {

        guard let id = object.id,
              let name = object.name,
              let emoji = object.emoji,
              let color = object.color as? UIColor else {
            return nil
        }

        var weekDaysModelArray: [WeekDaysModel] = []

        let arrayStringSchedule = object.schedule as? [String]

        arrayStringSchedule?.forEach {
            if let day = WeekDaysModel.fromRawValue($0) {
                weekDaysModelArray.append(day)
            }
        }

        return TrackerModel(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: weekDaysModelArray
        )
    }

    private func makeFetchRequest() -> NSFetchRequest<TrackerCoreData> {

        let fetchRequest = TrackerCoreData.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category", ascending: false)
        ]

        if let searchName = searchName {
            fetchRequest.predicate = NSPredicate(format: "name contains %@", searchName)
        }

        if let day = day {
            let fetchedObjects = try? context.fetch(fetchRequest)
            let filteredObjects = fetchedObjects?.filter { object in
                guard let schedule = object.schedule as? [WeekDaysModel] else { return false }
                let isInclude = schedule.contains(day) || schedule.isEmpty
                return isInclude
            }

            if let filteredObjects = filteredObjects {
                fetchRequest.predicate = NSPredicate(format: "self in %@", filteredObjects)
            } else {
                fetchRequest.predicate = nil
            }
        }

        return fetchRequest
    }

    private func createFetchedResultsController(
        fetchRequest: NSFetchRequest<TrackerCoreData>
    ) -> NSFetchedResultsController<TrackerCoreData> {

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        do {
            delegate?.didUpdate()
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform fetch: \(error.localizedDescription)")
        }

        return fetchedResultsController
    }

    func refreshFetchResults() {
        frcStore = createFetchedResultsController(fetchRequest: makeFetchRequest())
        delegate?.didUpdate()
    }
}

// MARK: - TrackerStoreDelegate

extension TrackerStore {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {

    var numberOfSections: Int {
        frcStore?.sections?.count ?? 0
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        frcStore?.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> TrackerModel? {

        guard let object = frcStore?.object(at: indexPath) else { return nil }

        return castInTrackerModel(for: object)
    }
}
