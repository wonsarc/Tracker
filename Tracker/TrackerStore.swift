//
//  TrackerStore.swift
//  Tracker
//
//  Created by Artem Krasnov on 05.05.2024.
//

import UIKit

final class TrackerStore {
    
    let coreDataManager = CoreDataManager.shared
    
    func addTracker(name: String) {
        let context = coreDataManager.getContext()
        
        let tracker = TrackerData(context: context)
        tracker.name = "123"
        coreDataManager.saveContext()
    }
}


