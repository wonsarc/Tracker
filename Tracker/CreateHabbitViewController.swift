//
//  CreateHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 31.03.2024.
//

import UIKit

final class CreateHabbitViewController: UIViewController, CreateEventAndHabbitProtocol {

    // MARK: - Public Properties

    weak var delegate: CreateTrackerExtensionsDelegate?
    var isHeaderVisible = false
    var detailTextLabel = ""

    lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Новая привычка")
        return titleLabel
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
    private var schedule: [WeekDaysModel] = []

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
    }

    @objc private func didTapCanceledButton() {
        cancelButtonAction()
    }

    @objc private func didTapCreateHabbitButton() {
        createButtonAction(name: nameTrackerTextField.text, schedule: schedule)
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
        settingsTableView.reloadData()
    }
}

// MARK: - SchedulerViewControllerDelegate

extension CreateHabbitViewController: SchedulerViewControllerDelegate {

    func schedulerViewController(_ viewController: SchedulerViewController, didSelectDays days: [WeekDaysModel]) {
        schedule = days
        let weekdayStrings = days.map { $0.rawValue }
        selectedDays = weekdayStrings.joined(separator: ", ")
        settingsTableView.reloadData()
    }
}
