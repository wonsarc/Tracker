//
//  CreateHabbitViewSettingsCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 01.04.2024.
//

import UIKit

final class CreateHabbitViewSettingsCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .black

        return nameLabel
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: IdentityCellEnum.createHabbitViewSettingsCell.rawValue)
        accessoryType = .disclosureIndicator
        self.backgroundColor = .customGray
        setupNameLabel()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
}
