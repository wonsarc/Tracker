//
//  SchedulerViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 02.04.2024.
//

import UIKit

protocol SchedulerViewControllerDelegate: AnyObject {
    func schedulerViewController(_ viewController: SchedulerViewController, didSelectDays days: [WeekDaysModel])
}

final class SchedulerViewController: UIViewController {

    // MARK: - Public Properties

    weak var delegate: SchedulerViewControllerDelegate?

    // MARK: - Private Properties

    private var selectIndexSet: Set<Int> = []

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString(
            "schedulerVC.titleLabel.text",
            comment: "")

        return titleLabel
    }()

    private lazy var schedulerTableView: UITableView = {
        let schedulerTableView = UITableView()
        schedulerTableView.translatesAutoresizingMaskIntoConstraints = false
        schedulerTableView.register(
            SchedulerTableViewCell.self,
            forCellReuseIdentifier: IdentityCellEnum.schedulerTableViewCell.rawValue
        )
        schedulerTableView.tableFooterView = UIView(frame: .zero)
        schedulerTableView.rowHeight = 75
        schedulerTableView.layer.cornerRadius = 16
        schedulerTableView.layer.masksToBounds = true
        schedulerTableView.dataSource = self
        schedulerTableView.delegate = self
        schedulerTableView.isScrollEnabled = false

        return schedulerTableView
    }()

    private lazy var doneButton: UIButton = {
        let doneButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapDoneButton)
        )

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.accessibilityIdentifier = "doneButton"
        doneButton.setTitle(NSLocalizedString(
            "schedulerVC.doneButton.text",
            comment: ""
        ), for: .normal)
        doneButton.tintColor = .white
        doneButton.titleLabel?.font = .systemFont(ofSize: 16)
        doneButton.backgroundColor = .black
        doneButton.layer.cornerRadius = 16

        return doneButton
    }()

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleLabel()
        setupSchedulerTableView()
        setupDoneButton()
    }

    // MARK: - Private Methods

    @objc private func didTapDoneButton() {
        let selectDays = didSelectScheduler()
        delegate?.schedulerViewController(self, didSelectDays: selectDays)
        dismiss(animated: true)
    }

    private func didSelectScheduler() -> [WeekDaysModel] {
        var days: [WeekDaysModel] = []

        let sortedIndexes = selectIndexSet.map {$0}.sorted()

        sortedIndexes.forEach {
            guard let day = WeekDaysModel.fromIndex($0) else { return }
            days.append(day)
        }

        return days
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupSchedulerTableView() {
        view.addSubview(schedulerTableView)

        schedulerTableView.heightAnchor.constraint(equalToConstant: 525).isActive = true
        schedulerTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        schedulerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        schedulerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

    private func setupDoneButton() {
        view.addSubview(doneButton)

        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -16
        ).isActive = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SchedulerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.schedulerTableViewCell.rawValue
        ) as? SchedulerTableViewCell

        guard let cell = cell else { return UITableViewCell()}

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        let weekDays = calendar.weekdaySymbols

        let day = indexPath.row == weekDays.count - 1 ? weekDays[0] : weekDays[indexPath.row + 1]

        cell.textLabel?.text = day.capitalized
        cell.selectionStyle = .none

        cell.switchValueChangedHandler = { [weak self] isOn in
            guard self != nil else { return }
            if isOn {
                self?.selectIndexSet.insert(indexPath.row)
            } else {
                self?.selectIndexSet.remove(indexPath.row)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        }
    }
}
