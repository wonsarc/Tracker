//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData
import UIKit

final class TrackerRecordStore {

    // MARK: - Private Properties

    private let context: NSManagedObjectContext

    // MARK: - Initializers

    init() {
        self.context = CoreDataManager.shared.getContext()
    }

    // MARK: - Public Methods

    func addRecord(_ record: TrackerRecordModel) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = getDateWithoutTime(from: record.date)
        try context.save()
    }

    func deleteTrackerRecord(id: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@",
                                             id as CVarArg,
                                             getDateWithoutTime(from: date) as CVarArg)

        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }

            try context.save()
            print("Запись с id \(id) и датой \(date) удалена успешно")
        } catch {
            print("Ошибка при удалении записи: \(error.localizedDescription)")
        }
    }

    func countFetch(_ id: UUID? = nil) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.resultType = .countResultType

        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }

        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {}

        return 0
    }

    func isTrackerDone(with id: UUID, for date: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@",
                                             id as CVarArg,
                                             getDateWithoutTime(from: date) as CVarArg)

        let results = try? context.fetch(fetchRequest)

        return !(results?.isEmpty ?? true)
    }

    func getDateWithoutTime(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }
}
