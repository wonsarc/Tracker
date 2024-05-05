//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

final class TrackerRecordStore {

    let coreDataManager = CoreDataManager.shared

    func addTrackerRecord(name: String) {
        let context = coreDataManager.getContext()

        let trackerRecord = TrackerRecordData(context: context)
        trackerRecord.date = Date()
        coreDataManager.saveContext()
    }
}
