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

    private var selectDays: [WeekDaysModel] = []

    private lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Расписание")
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

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleLabel()
        setupSchedulerTableView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        delegate?.schedulerViewController(self, didSelectDays: selectDays)
    }

    // MARK: - Overrides Methods

    // MARK: - IB Actions

    // MARK: - Public Methods

    func didSelectScheduler() -> [WeekDaysModel] {
        return selectDays
    }

    // MARK: - Private Methods

    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140).isActive = true
    }

    private func setupSchedulerTableView() {
        view.addSubview(schedulerTableView)

        schedulerTableView.heightAnchor.constraint(equalToConstant: 525).isActive = true
        schedulerTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        schedulerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        schedulerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
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
        calendar.locale = Locale(identifier: "ru_RU")
        let weekDays = calendar.weekdaySymbols

        let day = indexPath.row == weekDays.count - 1 ? weekDays[0] : weekDays[indexPath.row + 1]

        cell.textLabel?.text = day.capitalized
        cell.selectionStyle = .none

        cell.switchValueChangedHandler = { [weak self] _ in
            guard self != nil else { return }
            if let day = WeekDaysModel.fromIndex(indexPath.row) {
                self?.selectDays.append(day)
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
