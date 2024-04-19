//
//  SchedulerTableViewCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 03.04.2024.
//

import UIKit

final class SchedulerTableViewCell: UITableViewCell {

    var switchValueChangedHandler: ((Bool) -> Void)?

    // MARK: - Private Properties

    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = .systemFont(ofSize: 17)
        dayLabel.textColor = .black

        return dayLabel
    }()

    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false
        toggleSwitch.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        toggleSwitch.addTarget(
            self,
            action: #selector(toggleChanged(_:)),
            for: .valueChanged
        )

        return toggleSwitch
    }()
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: IdentityCellEnum.schedulerTableViewCell.rawValue)
        self.backgroundColor = .customGray
        setupDayLabel()
        setupToggleSwitch()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupDayLabel() {
        addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26.5).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }

    private func setupToggleSwitch() {
        contentView.addSubview(toggleSwitch)
        toggleSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }

    @objc func toggleChanged(_ sender: UISwitch) {
        switchValueChangedHandler?(sender.isOn)
    }
}
