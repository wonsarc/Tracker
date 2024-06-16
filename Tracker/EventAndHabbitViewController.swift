//
//  EventAndHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 14.06.2024.
//

import UIKit

protocol EventAndHabbitViewControllerProtocol: AnyObject {
    var presenter: EventAndHabbitPresenterProtocol? { get set }
    var emojiList: [String] { get }
    var colorList: [UIColor] { get }
    var trackerStore: TrackerStore { get }
    var typeScreen: EventAndHabbitType { get }
}

final class EventAndHabbitViewController: UIViewController, EventAndHabbitViewControllerProtocol {

    // MARK: - Public Properties

    var presenter: EventAndHabbitPresenterProtocol?
    let trackerStore: TrackerStore
    let typeScreen: EventAndHabbitType
    let action: EventAndHabbitAction

    let emojiList = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    let colorList = Colors.shared.availableСolors

    // MARK: - Private Properties

    private var isHeaderVisible = false

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString(
            typeScreen == .habbit ? "createHabbitVC.titleLabel.text" : "createEventVC.titleLabel.text",
            comment: "")

        return titleLabel
    }()

    private lazy var scrollUIView: UIScrollView = {
        let scrollUIView = UIScrollView()
        scrollUIView.translatesAutoresizingMaskIntoConstraints = false
        scrollUIView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollUIView.alwaysBounceVertical = true
        scrollUIView.showsHorizontalScrollIndicator = false

        return scrollUIView
    }()

    private lazy var nameTrackerTextField: UITextField = {
        let nameTrackerTextField = UITextField()
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.textColor = .black
        nameTrackerTextField.borderStyle = .none
        nameTrackerTextField.layer.cornerRadius = 16
        nameTrackerTextField.backgroundColor = .customGray
        nameTrackerTextField.clearButtonMode = .always

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        nameTrackerTextField.leftView = leftView
        nameTrackerTextField.leftViewMode = .always

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]

        let attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString(
                "createVC.nameTrackerTextField.text",
                comment: ""),
            attributes: placeholderAttributes
        )
        nameTrackerTextField.attributedPlaceholder = attributedPlaceholder

        return nameTrackerTextField
    }()

    private lazy var limitUILabel: UILabel = {
        let limitUILabel = UILabel()
        limitUILabel.translatesAutoresizingMaskIntoConstraints = false
        limitUILabel.textColor = .red
        limitUILabel.font = .systemFont(ofSize: 17)
        limitUILabel.textAlignment = .center
        limitUILabel.text = NSLocalizedString(
            "createVC.nameTrackerTextField.text",
            comment: ""
        )
        limitUILabel.isHidden = true

        return limitUILabel
     }()

    private lazy var settingsTableView: UITableView = {

        let settingsTableView = UITableView()
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.tableFooterView = UIView(frame: .zero)
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.masksToBounds = true
        settingsTableView.isScrollEnabled = false

        settingsTableView.register(
            EventAndHabbitViewSettingsCell.self,
            forCellReuseIdentifier: IdentityCellEnum.createHabbitViewSettingsCell.rawValue
        )

        if typeScreen == .event {
            settingsTableView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        }

        settingsTableView.dataSource = self
        settingsTableView.delegate = self

        return settingsTableView
    }()

    private lazy var emojiAndColorCollectionView: UICollectionView = {
        let emojiAndColorCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
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
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionView.isScrollEnabled = false

        return emojiAndColorCollectionView
    }()

    private lazy var canceledButton: UIButton = {

        let canceledButton = UIButton.systemButton(
            with: UIImage(),
            target: target,
            action: #selector(didTapCanceledButton)
        )

        canceledButton.translatesAutoresizingMaskIntoConstraints = false
        canceledButton.accessibilityIdentifier = "canceledButton"
        canceledButton.setTitle(
            NSLocalizedString("extensionUIVC.canceledButton.title.text", comment: ""),
            for: .normal
        )
        canceledButton.layer.borderWidth = 1
        canceledButton.layer.borderColor = UIColor.red.cgColor
        canceledButton.tintColor = .red
        canceledButton.titleLabel?.font = .systemFont(ofSize: 16)
        canceledButton.layer.cornerRadius = 16

        return canceledButton
     }()

    private lazy var createdButton: UIButton = {

        let createdButton = UIButton.systemButton(
            with: UIImage(),
            target: target,
            action: #selector(didTapCreateButton)
        )

        createdButton.translatesAutoresizingMaskIntoConstraints = false
        createdButton.accessibilityIdentifier = "createdButton"
        createdButton.setTitle(
            NSLocalizedString("extensionUIVC.createdButton.title.text", comment: ""),
            for: .normal
        )
        createdButton.tintColor = .white
        createdButton.titleLabel?.font = .systemFont(ofSize: 16)
        createdButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        createdButton.layer.cornerRadius = 16
        createdButton.isEnabled = false

        return createdButton
     }()

    // MARK: - Initializers

    init(trackerStore: TrackerStore, typeScreen: EventAndHabbitType, action: EventAndHabbitAction) {
        self.trackerStore = trackerStore
        self.typeScreen = typeScreen
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let eventAndHabbitPresenter = EventAndHabbitPresenter(trackerStore: trackerStore)
        self.presenter = eventAndHabbitPresenter
        eventAndHabbitPresenter.view = self

        setupViews()
        setupConstraints()
        nameTrackerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateScrollViewContentSize()
    }

    // MARK: - Public Methods

    func createTextFieldCheckAction(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 38 {
            textField.deleteBackward()
            isHeaderVisible = true
        } else {
            isHeaderVisible = false
        }

        settingsTableView.reloadData()
        limitUILabel.isHidden = !isHeaderVisible
        createdButton.isEnabled = !isHeaderVisible
    }

    // MARK: - Private Methods

    @objc private func textFieldDidChange(_ textField: UITextField) {
        createTextFieldCheckAction(textField)
        presenter?.trackerName = textField.text
        canCreateTracker()
    }

    @objc private func didTapCanceledButton() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapCreateButton() {
        guard let presenter = presenter else { return }

        presenter.createNewTracker()

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }

    private func canCreateTracker() {
        guard let presenter = presenter else { return }

        let isCanCreateTracker = presenter.validateTracker()

        createdButton.backgroundColor = isCanCreateTracker ?
            .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)

        createdButton.isEnabled = isCanCreateTracker
    }

    private func updateScrollViewContentSize() {
        var contentRect = CGRect.zero

        for view in scrollUIView.subviews {
            contentRect = contentRect.union(view.frame)
        }

        scrollUIView.contentSize = contentRect.size
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(scrollUIView)
        scrollUIView.addSubview(nameTrackerTextField)
        scrollUIView.addSubview(settingsTableView)
        scrollUIView.addSubview(emojiAndColorCollectionView)
        scrollUIView.addSubview(canceledButton)
        scrollUIView.addSubview(createdButton)
    }

    private func setupConstraints() {

        let topAnchor: CGFloat = !isHeaderVisible ? 0 : 24

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollUIView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollUIView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nameTrackerTextField.topAnchor.constraint(equalTo: scrollUIView.topAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            settingsTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: topAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: 200),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emojiAndColorCollectionView.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 8),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 525),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            canceledButton.widthAnchor.constraint(equalToConstant: 166),
            canceledButton.heightAnchor.constraint(equalToConstant: 60),
            canceledButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            canceledButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: -16),

            createdButton.widthAnchor.constraint(equalToConstant: 161),
            createdButton.heightAnchor.constraint(equalToConstant: 60),
            createdButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createdButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource

extension EventAndHabbitViewController: UITableViewDataSource {

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
        !isHeaderVisible ? 0 : 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.createHabbitViewSettingsCell.rawValue
        ) as? EventAndHabbitViewSettingsCell

        guard let cell = cell else { return UITableViewCell()}

        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .lightGray

        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("categoryVC.titleLabel.text", comment: "")
            cell.detailTextLabel?.text = presenter?.categoryName
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            cell.textLabel?.text = NSLocalizedString("schedulerVC.titleLabel.text", comment: "")
            cell.detailTextLabel?.text = presenter?.selectedDays
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        if typeScreen == .event {
            cell.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        typeScreen == .habbit ? 2 : 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            guard let categoryVC = presenter?.createCategoryVC() else { return }
            categoryVC.delegate = self
            present(categoryVC, animated: true)
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
        75
    }
}

// MARK: - UITableViewDelegate

extension EventAndHabbitViewController: UITableViewDelegate {}

// MARK: - CategoryViewControllerDelegate

extension EventAndHabbitViewController: CategoryViewControllerDelegate {

    func didSelectCategory(_ category: String) {
        presenter?.categoryName = category
        canCreateTracker()
        settingsTableView.reloadData()
    }
}

// MARK: - SchedulerViewControllerDelegate

extension EventAndHabbitViewController: SchedulerViewControllerDelegate {

    func schedulerViewController(_ viewController: SchedulerViewController, didSelectDays days: [WeekDaysModel]) {
        presenter?.updateSelectedDays(days: days)
        settingsTableView.reloadData()
        canCreateTracker()
    }
}

// MARK: - UICollectionViewDataSource

extension EventAndHabbitViewController: UICollectionViewDataSource {

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
                label.text = NSLocalizedString("createVC.cell.label.emoji.text", comment: "")
            } else {
                label.text = NSLocalizedString("createVC.cell.label.color.text", comment: "")
            }

            headerView.addSubview(label)
            return headerView
        }
        return UICollectionReusableView()
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

extension EventAndHabbitViewController: UICollectionViewDelegateFlowLayout {
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
            if let otherSelectedIndexPath = presenter?.selectedIndexPaths[0] {
                collectionView.deselectItem(at: otherSelectedIndexPath, animated: true)
                if let cell = collectionView.cellForItem(at: otherSelectedIndexPath) as? EmojiAndColorViewCell {
                    cell.contentUILabel.backgroundColor = .clear
                }
            }

            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorViewCell {
                cell.contentUILabel.backgroundColor = UIColor(hex: 0xE6E8EB)
                presenter?.currentEmoji = indexPath.row
                presenter?.selectedIndexPaths[0] = indexPath
                canCreateTracker()
            }

        } else {
            if let otherSelectedIndexPath = presenter?.selectedIndexPaths[1] {
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
                presenter?.currentColor = indexPath.row
                presenter?.selectedIndexPaths[1] = indexPath
                canCreateTracker()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension EventAndHabbitViewController: UICollectionViewDelegate {}
