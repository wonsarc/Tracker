//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Artem Krasnov on 14.05.2024.
//

import CoreData

final class CoreDataManager {

    // MARK: - Public Properties

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Initializers

    private init() {
        WeekDaysTransformer.register()
    }

    // MARK: - Public Methods

    func getContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
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
