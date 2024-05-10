//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

final class TrackerCategoryStore: NSObject {

    let context = CoreDataManager.shared.getContext()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: false)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        try? fetchedResultsController.performFetch()

        return fetchedResultsController
    }()
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {

}

extension TrackerCategoryStore: DataProviderProtocol {

    typealias T = TrackerCategoryCoreData

    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchedResultsController.object(at: indexPath)
    }

    func addRecord(_ record: TrackerCategoryCoreData) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
//        trackerRecordCoreData.id = record.id
//        trackerRecordCoreData.tracker = TrackerCoreData
//        trackerRecordCoreData.date = record.date
        CoreDataManager.shared.saveContext()
    }
}
