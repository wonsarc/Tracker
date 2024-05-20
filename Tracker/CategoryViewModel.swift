//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Artem Krasnov on 20.05.2024.
//

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {

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
