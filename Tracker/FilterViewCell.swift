//
//  FilterViewCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 12.06.2024.
//

import UIKit

final class FilterViewCell: UITableViewCell {

    // MARK: - Private Properties

     lazy var nameFilterLabel: UILabel = {
        let nameFilterLabel = UILabel()

         nameFilterLabel.translatesAutoresizingMaskIntoConstraints = false
         nameFilterLabel.font = .systemFont(ofSize: 17)
         nameFilterLabel.textColor = .black

        return nameFilterLabel
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: IdentityCellEnum.categoryViewCell.rawValue)
        self.backgroundColor = .customGray
        setupNameFilterLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupNameFilterLabel() {
        addSubview(nameFilterLabel)
        nameFilterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameFilterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }

}
