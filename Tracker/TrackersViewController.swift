//
//  TrackersViewController.swift.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Public Properties

    var categories: [TrackerCategoryModel] = []
    var completedTrackers: [TrackerRecordModel] = []
    var selectedDay: WeekDaysModel?
    var currentDate: Date? = Date()

    // MARK: - Private Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    private lazy var addTaskButton: UIButton = {
        let addTaskButton = UIButton.systemButton(
            with: UIImage(named: "plus") ?? UIImage(),
            target: self,
            action: #selector(didTapAddTaskButton)
        )
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.tintColor = .black
        addTaskButton.accessibilityIdentifier = "addTaskButton"

        return addTaskButton
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.accessibilityIdentifier = "datePicker"

        return datePicker
    }()

    private lazy var emptyTaskLabel: UILabel = {
        let emptyTaskLabel = UILabel()
        emptyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskLabel.text = "Что будем отслеживать?"
        emptyTaskLabel.textColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        emptyTaskLabel.font = .systemFont(ofSize: 12)
        emptyTaskLabel.textAlignment = .center
        return emptyTaskLabel
    }()

    private lazy var emptyTaskImageView: UIImageView = {
        let emptyTaskImageView = UIImageView()
        emptyTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskImageView.image = UIImage(named: "empty_tasks")
        return emptyTaskImageView
    }()

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()

        if categories.isEmpty {
            setupViewsForEmptyCategories()
            setupConstraintsForEmptyCategories()
            collectionView.isHidden = true
        } else {
            emptyTaskLabel.isHidden = true
            emptyTaskImageView.isHidden = true
            collectionView.isHidden = false
        }

        setupCollectionView()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let customCalendar = Calendar(identifier: .gregorian)

        currentDate = selectedDate

        var weekday = customCalendar.component(.weekday, from: selectedDate)
        weekday = (weekday - 2 + 7) % 7

        if let selectedDayOfWeek = WeekDaysModel.fromIndex(weekday) {
            self.selectedDay = selectedDayOfWeek
            collectionView.reloadData()
        }
    }

    // MARK: - Private Methods

    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: IdentityCellEnum.trackerCollectionViewCell.rawValue
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
    }

    private func setupViewsForEmptyCategories() {
        view.addSubview(emptyTaskLabel)
        view.addSubview(emptyTaskImageView)
    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTaskButton)
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: datePicker)

        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController

        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraintsForEmptyCategories() {

        NSLayoutConstraint.activate([
            emptyTaskImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTaskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyTaskLabel.heightAnchor.constraint(equalToConstant: 18),
            emptyTaskLabel.topAnchor.constraint(equalTo: emptyTaskImageView.bottomAnchor, constant: 8),
            emptyTaskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapAddTaskButton() {
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? SupplementaryView

        let category = categories[indexPath.section]

        headerView?.titleLabel.text = category.title

        return headerView ?? UICollectionReusableView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[section]

        if let trackers = category.trackers {
            let filteredTrackers = trackers.filter { tracker in
                if let selectedDay = selectedDay, let schedule = tracker.schedule {
                    return schedule.contains(selectedDay)
                } else {
                    return true
                }
            }
            return filteredTrackers.count
        } else {
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IdentityCellEnum.trackerCollectionViewCell.rawValue,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let category = categories[indexPath.section]

        if let tracker = category.trackers?[indexPath.row] {
            cell.configure(with: tracker, for: currentDate)
        }

        cell.delegate = self

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 148)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - CreateHabbitViewControllerDelegate

extension TrackersViewController: CreateTrackerViewControllerDelegate {

    func didCreateNewHabit() {
        categories = DataManager.shared.category
        collectionView.reloadData()

        if categories.isEmpty {
            collectionView.isHidden = true
            emptyTaskLabel.isHidden = false
            emptyTaskImageView.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyTaskLabel.isHidden = true
            emptyTaskImageView.isHidden = true
        }
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {

    func didTapDoneButton(for tracker: TrackerModel) {
        collectionView.reloadData()
    }
}
