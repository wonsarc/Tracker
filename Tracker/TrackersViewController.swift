//
//  TrackersViewController.swift.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Private Properties

    private let trackerStore = TrackerStore()
    private var selectedDay: WeekDaysModel?
    private var currentDate: Date? = Date()

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
        emptyTaskLabel.text = NSLocalizedString("trackersVC.emptyState.title", comment: "Text displayed on empty state")
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

        trackerStore.delegate = self

        setupNavBar()
        setupViewsForEmptyCategories()
        setupConstraintsForEmptyCategories()
        setupCollectionView()

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        updateSelectedDate(date: Date())
    }

    // MARK: - Public Methods

    private func updateSelectedDate (date selectedDate: Date) {
        let customCalendar = Calendar(identifier: .gregorian)

        var weekday = customCalendar.component(.weekday, from: selectedDate)
        weekday = (weekday - 2 + 7) % 7

        if let selectedDayOfWeek = WeekDaysModel.fromIndex(weekday) {
            self.selectedDay = selectedDayOfWeek
            trackerStore.day = selectedDay
        }
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate

        if let currentDate = currentDate {
            updateSelectedDate(date: currentDate)
        }
    }

    // MARK: - Private Methods

    private func updateUI() {

        let isHiddenEmptyLabel = trackerStore.numberOfSections != 0

        emptyTaskLabel.isHidden = isHiddenEmptyLabel
        emptyTaskImageView.isHidden = isHiddenEmptyLabel
        collectionView.isHidden = !isHiddenEmptyLabel
    }

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

        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString(
            "trackersVC.searchController.searchBar.placeholder",
            comment: ""
        )
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        navigationItem.title = NSLocalizedString("trackersVC.navigationItem.title", comment: "")
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
        viewController.trackerStore = self.trackerStore
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

        if let category = trackerStore.frcStore?.object(
            at: IndexPath(row: indexPath.row, section: indexPath.section)
        ).category {
            headerView?.titleLabel.text = category.title
        }

        return headerView ?? UICollectionReusableView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
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

        if let tracker = trackerStore.object(at: indexPath) {
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

// MARK: - TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {

    func didTapDoneButton(for tracker: TrackerModel) {
        collectionView.reloadData()
    }
}

// MARK: - TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {

    func didUpdate() {
        collectionView.reloadData()
        updateUI()
    }
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {

   func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            trackerStore.searchName = searchText
        } else {
            trackerStore.searchName = nil
        }
    }
}
