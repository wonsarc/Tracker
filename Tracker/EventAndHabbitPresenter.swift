//
//  EventAndHabbitPresenter.swift
//  Tracker
//
//  Created by Artem Krasnov on 14.06.2024.
//

import Foundation

protocol EventAndHabbitPresenterProtocol: AnyObject {
    var view: EventAndHabbitViewControllerProtocol? {get set}
    var categoryName: String? {get set}
    var trackerName: String? {get set}
    var selectedDays: String {get set}
    var selectedIndexPaths: [IndexPath?] {get set}
    var currentEmoji: Int? {get set}
    var currentColor: Int? {get set}

    func validateTracker() -> Bool
    func createNewTracker()
    func editTracker()
    func createCategoryVC() -> CategoryViewController
    func updateSelectedDays (days: [WeekDaysModel])
}

final class EventAndHabbitPresenter: EventAndHabbitPresenterProtocol {

    // MARK: - Public Properties

    weak var view: EventAndHabbitViewControllerProtocol?

    var trackerName: String?
    var categoryName: String?
    var selectedDays = ""
    var currentEmoji: Int?
    var currentColor: Int?
    var selectedIndexPaths: [IndexPath?] = [nil, nil]

    // MARK: - Private Properties

    private var currentSchedule: [WeekDaysModel] = []
    private let trackerStore: TrackerStore

    // MARK: - Initializers

    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
    }

    // MARK: - Overrides Methods

    // MARK: - Public Methods

    func validateTracker() -> Bool {
        categoryName != nil &&
        trackerName != nil &&
        currentColor != nil &&
        currentEmoji != nil &&
        view?.typeScreen == .habbit ? !currentSchedule.isEmpty : currentSchedule.isEmpty
    }

    func createNewTracker() {

        guard let view = view else { return }
        guard let name = trackerName,
              let indexColor = currentColor,
              let indexEmoji = currentEmoji else {
            fatalError("Cannot create TrackerModel without name, color, and emoji")
        }

        let newTracker = TrackerModel(
            id: UUID(),
            name: name,
            color: view.colorList[indexColor],
            emoji: view.emojiList[indexEmoji],
            schedule: currentSchedule
        )

        saveTracker(newTracker)
    }

    func editTracker() {
        guard let view = view,
              let id = view.editTrackerId,
              let indexColor = currentColor,
              let indexEmoji = currentEmoji else {
                fatalError("Cannot create edit tracker without id")
            }

        if let newTracker = try? trackerStore.getTracker(withId: id),
           let categoryName = categoryName {
            newTracker.name = trackerName
            newTracker.color = view.colorList[indexColor]
            newTracker.emoji = view.emojiList[indexEmoji]
            newTracker.schedule = currentSchedule as NSArray

            trackerStore.editTracker(newTracker, categoryName: categoryName)
        }
    }

    func createCategoryVC() -> CategoryViewController {
        let categoryModel = CategoryModel()
        let viewModel = CategoryViewModel(for: categoryModel)

        return CategoryViewController(viewModel: viewModel)
    }

    func updateSelectedDays (days: [WeekDaysModel]) {
        currentSchedule = days
        let weekdayStrings = days.map { $0.localizedString }
        selectedDays = weekdayStrings.joined(separator: ", ")
    }

    // MARK: - Private Methods

    private func saveTracker(_ newTracker: TrackerModel) {
        guard let categoryName = categoryName else { return }
        try? trackerStore.addRecord(newTracker, toCategoryWithName: categoryName)
        trackerStore.refreshFetchResults()
    }
}
