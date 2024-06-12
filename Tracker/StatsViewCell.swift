//
//  StatsViewCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 10.06.2024.
//

import UIKit

final class StatsViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var nameCellLabel: UILabel = {
        let nameCellLabel = UILabel()
        nameCellLabel.translatesAutoresizingMaskIntoConstraints = false

        nameCellLabel.font = .systemFont(ofSize: 12)
        nameCellLabel.text = NSLocalizedString("statsViewCell.nameCellLabel.text", comment: "")

        return nameCellLabel
    }()

     lazy var countCellLabel: UILabel = {
        let countCellLabel = UILabel()
        countCellLabel.translatesAutoresizingMaskIntoConstraints = false

        countCellLabel.font = .boldSystemFont(ofSize: 34)

        return countCellLabel
    }()

    // MARK: - Initializers

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: IdentityCellEnum.statsViewCell.rawValue)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.addGradienBorder(colors: [.red, . green, .blue], radius: 16)
    }

    // MARK: - Private Methods

    private func setupCell() {

        addSubview(countCellLabel)
        addSubview(nameCellLabel)

        countCellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        countCellLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true

        nameCellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        nameCellLabel.topAnchor.constraint(equalTo: countCellLabel.bottomAnchor, constant: 7).isActive = true
    }
}
