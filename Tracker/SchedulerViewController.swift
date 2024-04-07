//
//  SchedulerViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 02.04.2024.
//

import UIKit

final class SchedulerViewController: UIViewController {

    // MARK: - IB Outlets

    // MARK: - Public Properties

    // MARK: - Private Properties

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.text = "Расписание"

        return nameLabel
    }()

    private lazy var schedulerTableView: UITableView = {
        let schedulerTableView = UITableView()
        schedulerTableView.translatesAutoresizingMaskIntoConstraints = false
        schedulerTableView.register(SchedulerTableViewCell.self, forCellReuseIdentifier: "SchedulerCell")
        schedulerTableView.tableFooterView = UIView(frame: .zero)
        schedulerTableView.rowHeight = 75
        schedulerTableView.layer.cornerRadius = 16
        schedulerTableView.layer.masksToBounds = true
        schedulerTableView.dataSource = self
        schedulerTableView.delegate = self

        return schedulerTableView
    }()


    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNameLabel()
        setupSchedulerTableView()
    }

    // MARK: - Overrides Methods

    // MARK: - IB Actions

    // MARK: - Public Methods

    // MARK: - Private Methods

    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140).isActive = true
    }

    private func setupSchedulerTableView() {
        view.addSubview(schedulerTableView)

        schedulerTableView.heightAnchor.constraint(equalToConstant: 525).isActive = true
        schedulerTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24).isActive = true
        schedulerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        schedulerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SchedulerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulerCell") as? SchedulerTableViewCell

        guard let cell = cell else { return UITableViewCell()}

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        let weekDays = calendar.weekdaySymbols

        let day = indexPath.row == weekDays.count - 1 ? weekDays[0] : weekDays[indexPath.row + 1]

        cell.textLabel?.text = day.capitalized
        cell.selectionStyle = .none

        cell.switchValueChangedHandler = { [weak self] isOn in
            guard let self = self else { return }
            print("Переключатель включен: \(isOn)", day)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
