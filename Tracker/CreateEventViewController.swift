//
//  CreateEventViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 02.04.2024.
//

import UIKit

final class CreateEventViewController: UIViewController, CreateEventAndHabbitProtocol {

    // MARK: - Public Properties

    weak var delegate: CreateTrackerExtensionsDelegate?
    var detailTextLabel = ""
    var isHeaderVisible = false

    lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Новое нерегулярное событие")
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
            action: #selector(didTapCreateEventButton)
            )
        return createdButton
    }()

    // MARK: - Private Properties

    private var emojiList = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

   private var colorList: [UIColor] = [
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

    // MARK: - Private Methods

    @objc private func textFieldDidChange(_ textField: UITextField) {
        createTextFieldCheckAction(textField)
        updateAddCategoryButton()
    }

    @objc private func didTapCanceledButton() {
        cancelButtonAction()
    }

    @objc private func didTapCreateEventButton() {
        let newTracker = TrackerModel(
            name: nameTrackerTextField.text,
            color: .customGray,
            emoji: "",
            schedule: nil
        )
        createButtonAction(with: newTracker)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CreateEventViewController: UITableViewDelegate, UITableViewDataSource {

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
        cell.detailTextLabel?.text = detailTextLabel
        cell.textLabel?.text = "Категория"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self

        present(categoryViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - CategoryViewControllerDelegate

extension CreateEventViewController: CategoryViewControllerDelegate {

    func didSelectCategory(_ category: String) {
        detailTextLabel = category
        updateAddCategoryButton()
        settingsTableView.reloadData()
    }
}

// MARK: - SchedulerViewControllerDelegate

extension CreateEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            emojiList.count
        } else {
            colorList.count
        }
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

extension CreateEventViewController: UICollectionViewDelegateFlowLayout {
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
}
