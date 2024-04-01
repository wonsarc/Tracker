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
        super.init(style: style, reuseIdentifier: "cell")
        accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        setupNameLabel()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12).isActive = true
    }
}
