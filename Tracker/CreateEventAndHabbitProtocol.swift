//
//  CreateEventAndHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 19.04.2024.
//

import UIKit

protocol CreateEventAndHabbitProtocol: AnyObject {
    var titleLabel: UILabel { get }
    var nameTrackerTextField: UITextField { get }
    var limitUILabel: UILabel { get }
    var settingsTableView: UITableView { get }
    var canceledButton: UIButton { get }
    var createdButton: UIButton { get }
    var detailTextLabel: String { get set }
    var isHeaderVisible: Bool { get set }
    var delegate: CreateTrackerExtensionsDelegate? { get }

    func setupViews()
    func setupConstraints()
    func createTextFieldCheckAction(_ textField: UITextField)
    func createButtonAction(name: String?, schedule: [WeekDaysModel]?)
    func cancelButtonAction()
}

extension CreateEventAndHabbitProtocol where Self: UIViewController {

    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(settingsTableView)
        view.addSubview(canceledButton)
        view.addSubview(createdButton)
    }

    func setupConstraints() {

        let topAnchor: CGFloat = !isHeaderVisible ? 0 : 24

        NSLayoutConstraint.activate([

            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            settingsTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsTableView.bottomAnchor.constraint(equalTo: canceledButton.topAnchor, constant: -8),

            canceledButton.widthAnchor.constraint(equalToConstant: 166),
            canceledButton.heightAnchor.constraint(equalToConstant: 60),
            canceledButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            canceledButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            createdButton.widthAnchor.constraint(equalToConstant: 166),
            createdButton.heightAnchor.constraint(equalToConstant: 60),
            createdButton.leadingAnchor.constraint(equalTo: canceledButton.trailingAnchor, constant: 8),
            createdButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

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

    func cancelButtonAction() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func createButtonAction(name: String?, schedule: [WeekDaysModel]?) {

        let newTracker = TrackerModel(
            name: name,
            color: nil,
            emoji: nil,
            chedule: schedule
        )

        if let existingCategoryIndex = DataManager.shared.category.firstIndex(where: { $0.title == detailTextLabel }) {
            let category = DataManager.shared.category[existingCategoryIndex]
            let title = category.title
            var trackers = category.trackers
            trackers?.append(newTracker)

            let newTrackerCategory = TrackerCategoryModel(
                title: title,
                trackers: trackers
            )

            DataManager.shared.category.remove(at: existingCategoryIndex)
            DataManager.shared.category.append(newTrackerCategory)
        } else {
            let newTrackerCategory = TrackerCategoryModel(
                title: detailTextLabel,
                trackers: [newTracker]
            )
            DataManager.shared.category.append(newTrackerCategory)
        }

        delegate?.didCreateNewTracker()
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}
