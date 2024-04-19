//
//  CategoryViewCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.04.2024.
//

import UIKit

final class CategoryViewCell: UITableViewCell {

    // MARK: - Private Properties

     lazy var nameCategoryLabel: UILabel = {
        let nameCategoryLabel = UILabel()
        nameCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCategoryLabel.font = .systemFont(ofSize: 17)
        nameCategoryLabel.textColor = .black

        return nameCategoryLabel
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: IdentityCellEnum.categoryViewCell.rawValue)
        self.backgroundColor = .customGray
        setupNameCategoryLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupNameCategoryLabel() {
        addSubview(nameCategoryLabel)
        nameCategoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26.5).isActive = true
        nameCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }

}
