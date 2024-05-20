//
//  CategoryModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 20.05.2024.
//

import Foundation

final class CategoryModel {

    // MARK: - Private Properties

    private var categories: [String] = []

    // MARK: - Public Methods

    func getAllCategories() -> [String] {
        return TrackerCategoryStore().getAllTitle()
    }
}
