//
//  CreateHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 31.03.2024.
//

import UIKit

final class CreateHabbitViewController: UIViewController, CreateEventAndHabbitProtocol {

    // MARK: - Public Properties

    var detailTextLabel = ""
    var isHeaderVisible = false
    var trackerStore = TrackerStore()

    lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Новая привычка")
        return titleLabel
    }()

    lazy var scrollView = {
        let scrollView = self.scrollUIViewFactory()
        return scrollView
    }()

    lazy var nameTrackerTextField: UITextField = {
        let textField = self.textFieldFactory(withPlaceholder: "Введите название трекера")
        return textField
    }()

    lazy var limitUILabel: UILabel = {
        let limitUILabel = self.limitUILabelFactory(withText: "Ограничение 38 символов")
        return limitUILabel
    }()

    lazy var settingsTableView: UITableView = {
        let settingsTableView = self.settingsTableViewFactory()

        settingsTableView.register(
            CreateHabbitViewSettingsCell.self,
            forCellReuseIdentifier: IdentityCellEnum.createHabbitViewSettingsCell.rawValue
        )

        settingsTableView.dataSource = self
        settingsTableView.delegate = self

        return settingsTableView
    }()

    lazy var emojiAndColorCollectionView: UICollectionView = {
        let emojiAndColorCollectionView = self.emojiAndColorCollectionViewFactory()
        emojiAndColorCollectionView.dataSource = self
        emojiAndColorCollectionView.delegate = self
        emojiAndColorCollectionView.register(
            EmojiAndColorViewCell.self,
            forCellWithReuseIdentifier: IdentityCellEnum.emojiAndColorViewCell.rawValue
        )
        emojiAndColorCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: IdentityCellEnum.headerViewIdentifier.rawValue
        )

        return emojiAndColorCollectionView
    }()

    lazy var canceledButton: UIButton = {
        let canceledButton = self.cancelButtonFactory(
            target: self,
            action: #selector(didTapCanceledButton)
        )
        return canceledButton
    }()

    lazy var createdButton: UIButton = {
        let createdButton = self.createdButtonFactory(
            target: self,
            action: #selector(didTapCreateHabbitButton)
        )
        return createdButton
    }()

    // MARK: - Private Properties

    private var selectedDays = ""
    private var currentEmoji: String?
    private var currentColor: UIColor?
    private var currentSchedule: [WeekDaysModel] = []
    private var selectedIndexPaths: [IndexPath?] = [nil, nil]

    private let emojiList = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

   private let colorList: [UIColor] = [
        UIColor(hex: 0xFD4C49), UIColor(hex: 0xFF881E), UIColor(hex: 0x007BFA),
        UIColor(hex: 0x6E44FE), UIColor(hex: 0x33CF69), UIColor(hex: 0xE66DD4),
        UIColor(hex: 0xF9D4D4), UIColor(hex: 0x34A7FE), UIColor(hex: 0x46E69D),
        UIColor(hex: 0x35347C), UIColor(hex: 0xFF674D), UIColor(hex: 0xFF99CC),
        UIColor(hex: 0xF6C48B), UIColor(hex: 0x7994F5), UIColor(hex: 0x832CF1),
        UIColor(hex: 0xAD56DA), UIColor(hex: 0x8D72E6), UIColor(hex: 0x2FD058)
    ]

    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        nameTrackerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateScrollViewContentSize()
    }

    // MARK: - Private Methods

    private func updateScrollViewContentSize() {
        var contentRect = CGRect.zero

        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }

        scrollView.contentSize = contentRect.size
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        createTextFieldCheckAction(textField)
        canCreateTracker()
    }

    @objc private func didTapCanceledButton() {
        cancelButtonAction()
    }

    @objc private func didTapCreateHabbitButton() {
        let newTracker = createNewTracker()
        createButtonAction(with: newTracker)
    }

    private func canCreateTracker() {
        let isCanCreateTracker = detailTextLabel != "" &&
        nameTrackerTextField.text != nil &&
        nameTrackerTextField.text != "" &&
        currentColor != nil &&
        currentEmoji != nil &&
        !currentSchedule.isEmpty

        createdButton.backgroundColor = isCanCreateTracker ?
            .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)

        createdButton.isEnabled = isCanCreateTracker
    }

    private func createNewTracker() -> TrackerModel {
        guard let name = nameTrackerTextField.text,
              let color = currentColor,
              let emoji = currentEmoji else {
                  fatalError("Cannot create TrackerModel without name, color, and emoji")
              }

        let newTracker = TrackerModel(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: currentSchedule
        )

        return newTracker
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateHabbitViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = limitUILabel
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !isHeaderVisible ? 0 : 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.createHabbitViewSettingsCell.rawValue
        ) as? CreateHabbitViewSettingsCell

        guard let cell = cell else { return UITableViewCell()}

        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .lightGray

        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = detailTextLabel
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            cell.textLabel?.text = "Расписание"
            cell.detailTextLabel?.text = selectedDays
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            present(categoryViewController, animated: true)
        } else {
            let schedulerViewController = SchedulerViewController()
            schedulerViewController.delegate = self
            present(schedulerViewController, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - CategoryViewControllerDelegate

extension CreateHabbitViewController: CategoryViewControllerDelegate {

    func didSelectCategory(_ category: String) {
        detailTextLabel = category
        canCreateTracker()
        settingsTableView.reloadData()
    }
}

// MARK: - SchedulerViewControllerDelegate

extension CreateHabbitViewController: SchedulerViewControllerDelegate {

    func schedulerViewController(_ viewController: SchedulerViewController, didSelectDays days: [WeekDaysModel]) {
        currentSchedule = days
        let weekdayStrings = days.map { $0.rawValue }
        selectedDays = weekdayStrings.joined(separator: ", ")
        settingsTableView.reloadData()
        canCreateTracker()
    }
}

// MARK: - UICollectionViewDataSource

extension CreateHabbitViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        UIEdgeInsets(top: 30, left: 0, bottom: 16, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: IdentityCellEnum.headerViewIdentifier.rawValue,
                for: indexPath
            )

            let label = UILabel(
                frame: CGRect(
                    x: 16,
                    y: 0,
                    width: headerView.frame.width - 32,
                    height: headerView.frame.height
                )
            )

            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 19)

            if indexPath.section == 0 {
                label.text = "Emoji"
            } else {
                label.text = "Цвет"
            }

            headerView.addSubview(label)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? emojiList.count: colorList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IdentityCellEnum.emojiAndColorViewCell.rawValue,
            for: indexPath
        ) as? EmojiAndColorViewCell

        if indexPath.section == 0 {
            cell?.contentUILabel.text = emojiList[indexPath.row]
            cell?.contentUILabel.backgroundColor = .clear
            return cell ?? UICollectionViewCell()
        } else {
            cell?.contentUILabel.text = ""
            cell?.contentUILabel.backgroundColor = colorList[indexPath.row]

            return cell ?? UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateHabbitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 6, height: 50)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            if let otherSelectedIndexPath = selectedIndexPaths[0] {
                collectionView.deselectItem(at: otherSelectedIndexPath, animated: true)
                if let cell = collectionView.cellForItem(at: otherSelectedIndexPath) as? EmojiAndColorViewCell {
                    cell.contentUILabel.backgroundColor = .clear
                }
            }

            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorViewCell {
                cell.contentUILabel.backgroundColor = UIColor(hex: 0xE6E8EB)
                currentEmoji = emojiList[indexPath.row]
                selectedIndexPaths[0] = indexPath
                canCreateTracker()
            }

        } else {
            if let otherSelectedIndexPath = selectedIndexPaths[1] {
                collectionView.deselectItem(at: otherSelectedIndexPath, animated: true)
                if let cell = collectionView.cellForItem(at: otherSelectedIndexPath) as? EmojiAndColorViewCell {
                    cell.cellUIView.layer.borderWidth = 0
                }
            }

            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorViewCell {
                let color = cell.contentUILabel.backgroundColor
                guard let borderColor = color?.withAlphaComponent(0.3).cgColor else { return }
                cell.cellUIView.layer.borderColor = borderColor
                cell.cellUIView.layer.borderWidth = 3
                currentColor = color
                selectedIndexPaths[1] = indexPath
                canCreateTracker()
            }

        }
    }
}
