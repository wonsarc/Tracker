//
//  CreateTrackerViewModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 26.05.2024.
//

import Foundation

final class CreateTrackerViewModel {

    // MARK: - Public Properties

    var categories: Binding<[String]>?

    // MARK: - Private Properties

    private let model: CategoryModel

    // MARK: - Initializers

    init(for model: CategoryModel) {
        self.model = model
    }

    // MARK: - Public Methods

    func fetchCategories() {
        let categoryData = model.getAllCategories()
        categories?(categoryData)
    }
}
