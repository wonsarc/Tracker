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

    var day: Date? {
        didSet {
            refreshFetchResults()
        }
    }

    var searchName: String? {
        didSet {
            refreshFetchResults()
        }
    }

    var globalFilter: FilterModel? {
        didSet {
            if globalFilter != .today {
                refreshFetchResults()
            }
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
        var predicates: [NSPredicate] = []

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category", ascending: false)
        ]

        if let searchName = searchName {
            let predicateSearchName = NSPredicate(format: "name contains[c] %@", searchName)
            predicates.append(predicateSearchName)
        }

        if let day = convertDate(date: day ?? Date()) {
            let fetchedObjects = try? context.fetch(fetchRequest)
            let filteredObjects = fetchedObjects?.filter { object in
                guard let schedule = object.schedule as? [WeekDaysModel] else { return false }
                let isInclude = schedule.contains(day) || schedule.isEmpty
                return isInclude
            }

            if let filteredObjects = filteredObjects {
                let predicateDay = NSPredicate(format: "self in %@", filteredObjects)
                predicates.append(predicateDay)
            }
        }

        if let globalFilter = globalFilter {

            let fetchedObjects = try? context.fetch(fetchRequest)
            let trackerRecordStore = TrackerRecordStore()
            let filteredObjects = fetchedObjects?.filter { object in
                guard let id = object.id,
                      let day =  day else { return false }

                return trackerRecordStore.isTrackerDone(with: id, for: day)
            }

            if let filteredObjects = filteredObjects {
                if globalFilter == .complete {
                    let predicateComplete = NSPredicate(format: "self in %@", filteredObjects)
                    predicates.append(predicateComplete)
                } else if globalFilter == .uncomplete {
                    let predicateUncomplete = NSPredicate(format: "NOT (self IN %@)", filteredObjects)
                    predicates.append(predicateUncomplete)

                }
            }
        }

        fetchRequest.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        return fetchRequest
    }

    private func convertDate(date selectedDate: Date) -> WeekDaysModel? {
        let customCalendar = Calendar(identifier: .gregorian)

        var weekday = customCalendar.component(.weekday, from: selectedDate)
        weekday = (weekday - 2 + 7) % 7

        return WeekDaysModel.fromIndex(weekday)
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
