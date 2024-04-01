//
//  TrackerModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 14.03.2024.
//

import UIKit

struct TrackerModel {
    let id = UUID()
    let name: String?
    let color: UIColor?
    let emoji: UILabel?
    let chedule: Date? // todo maybe new struct schedule?
}