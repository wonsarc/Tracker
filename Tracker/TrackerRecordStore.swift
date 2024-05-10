//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

final class TrackerRecordStore: NSObject {

    let context = CoreDataManager.shared.getContext()

    func countFetchByIdAndDate(id: UUID, date: Date) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as CVarArg)

        do {
            let count = try context.count(for: fetchRequest)
            print("Количество записей для трекера с id \(id) и датой \(date): \(count)")
            return count
        } catch {
            print("Ошибка при выполнении запроса: \(error.localizedDescription)")
        }
        return 0
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

    func addRecord(_ record: TrackerRecordModel) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = record.date
        CoreDataManager.shared.saveContext()
    }

    func deleteTrackerRecord(id: UUID, date: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as CVarArg)

        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record) // Удалить объект из контекста CoreData
            }

            try context.save() // Сохранить изменения
            print("Запись с id \(id) и датой \(date) удалена успешно")
        } catch {
            print("Ошибка при удалении записи: \(error.localizedDescription)")
        }
    }
}
