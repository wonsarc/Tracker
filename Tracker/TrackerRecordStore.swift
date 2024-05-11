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

    func addRecord(_ record: TrackerRecordModel) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = record.date
        try context.save()
    }

    func deleteTrackerRecord(id: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as CVarArg)

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

    func countFetchById(id: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let count = try context.count(for: fetchRequest)
            print("Количество записей для трекера с id \(id): \(count)")
            return count
        } catch {
            print("Ошибка при выполнении запроса: \(error.localizedDescription)")
        }
        return 0
    }

    func isTrackerDone(with id: UUID, for date: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as CVarArg)

        let results = try?context.fetch(fetchRequest)

        return !(results?.isEmpty ?? true)
    }
}
