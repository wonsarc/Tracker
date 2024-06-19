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
    private let colors = Colors.shared
    private var selectedDay: Date = Date()
    private var currentFilter: FilterModel = .all
    private let screenName = "Main"

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
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
        addTaskButton.tintColor = colors.buttonColor
        addTaskButton.accessibilityIdentifier = "addTaskButton"

        return addTaskButton
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = colors.dataPickerColor
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.preferredDatePickerStyle = .compact
        datePicker.accessibilityIdentifier = "datePicker"

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        return datePicker
    }()

    private lazy var emptyTaskLabel: UILabel = {
        let emptyTaskLabel = UILabel()
        emptyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskLabel.text = NSLocalizedString("trackersVC.emptyState.title", comment: "Text displayed on empty state")
        emptyTaskLabel.textColor = colors.textColor
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

    private lazy var filtersButton: UIButton = {

        let filtersButton = UIButton.systemButton(
            with: UIImage(),
            target: target,
            action: #selector(didTapFilterButton)
        )

        filtersButton.translatesAutoresizingMaskIntoConstraints = false

        filtersButton.setTitle(NSLocalizedString("trackersVC.filterButton.title", comment: ""), for: .normal)
        filtersButton.titleLabel?.font = .systemFont(ofSize: 17)
        filtersButton.tintColor = .white
        filtersButton.backgroundColor = colors.filterButton
        filtersButton.layer.cornerRadius = 16

        return filtersButton

    }()

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor

        trackerStore.delegate = self

        setupNavBar()
        setupViewsForEmptyCategories()
        setupConstraintsForEmptyCategories()
        setupCollectionView()
        setupFilterButton()

        trackerStore.day = selectedDay
        AnalyticsService.eventOpenScreen(screenName)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.eventCloseScreen(screenName)
    }

    // MARK: - Public Methods

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDay = sender.date
        trackerStore.day = selectedDay

        if currentFilter == .today {
            currentFilter = .all
            trackerStore.globalFilter = .all
        }
    }

    // MARK: - Private Methods

    @objc private func didTapFilterButton() {
        let filterVC = FilterViewController(currentFilter: currentFilter)
        filterVC.delegate = self
        present(filterVC, animated: true)
        AnalyticsService.eventClick(on: screenName, for: .filter)
    }

    private func updateUI() {

        let isHiddenEmptyLabel = trackerStore.numberOfSections != 0

        emptyTaskLabel.isHidden = isHiddenEmptyLabel
        emptyTaskImageView.isHidden = isHiddenEmptyLabel
        collectionView.isHidden = !isHiddenEmptyLabel
        filtersButton.isHidden = !isHiddenEmptyLabel
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

    private func setupFilterButton() {
        view.addSubview(filtersButton)

        filtersButton.widthAnchor.constraint(equalToConstant: 114).isActive = true
        filtersButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -16
        ).isActive = true
    }

    @objc private func didTapAddTaskButton() {
        let viewController = CreateTrackerViewController()
        viewController.trackerStore = self.trackerStore
        present(viewController, animated: true)
        AnalyticsService.eventClick(on: screenName, for: .addTrack)
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
            cell.configure(with: tracker, for: selectedDay)
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

// MARK: - FilterViewControllerDelegate

extension TrackersViewController: FilterViewControllerDelegate {

    func didSelectFilter(_ filter: FilterModel) {

        switch filter {
        case .all:
            trackerStore.globalFilter = .all
            currentFilter = filter

        case .today:
            trackerStore.globalFilter = .today
            datePicker.date = Date()
            datePickerValueChanged(datePicker)
            currentFilter = filter

        case .complete:
            trackerStore.globalFilter = .complete
            currentFilter = filter

        case .uncomplete:
            trackerStore.globalFilter = .uncomplete
            currentFilter = filter
        }
    }
}
