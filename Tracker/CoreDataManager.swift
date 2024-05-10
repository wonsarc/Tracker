//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import CoreData

protocol DataProviderProtocol {
    associatedtype T
    func object(at indexPath: IndexPath) -> T?
    func addRecord(_ record: T) throws
}

final class CoreDataManager {

    static let shared = CoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        registerTransformerValues()

        return container
    }()

    private func registerTransformerValues() {
        DaysValueTransformer.register()
    }

    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
