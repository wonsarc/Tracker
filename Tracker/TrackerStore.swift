//
//  TrackerStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

final class TrackerStore: NSObject {

    let context = CoreDataManager.shared.getContext()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {

        let fetchRequest = TrackerCoreData.fetchRequest()

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: false)
        ]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, // todo
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        try? fetchedResultsController.performFetch()

        return fetchedResultsController
    }()
}

extension TrackerStore: NSFetchedResultsControllerDelegate {

    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 1
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

}

extension TrackerStore: DataProviderProtocol {

    typealias T = TrackerCoreData

    func object(at indexPath: IndexPath) -> TrackerCoreData? {
        fetchedResultsController.object(at: indexPath)
    }

    func addRecord(_ record: TrackerCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)

        trackerCoreData.name = record.name
        trackerCoreData.category = record.category
        trackerCoreData.color = record.color
        trackerCoreData.emoji = record.emoji
        trackerCoreData.schedule = record.schedule

        CoreDataManager.shared.saveContext()
    }
}
