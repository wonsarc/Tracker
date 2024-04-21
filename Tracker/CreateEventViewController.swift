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
            action: #selector(didTapCreateEventButton)
            )
        return createdButton
    }()

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
        createButtonAction(name: nameTrackerTextField.text, schedule: nil)
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
