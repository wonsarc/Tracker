//
//  EmojiAndColorViewCell.swift
//  Tracker
//
//  Created by Artem Krasnov on 21.04.2024.
//

import UIKit

final class EmojiAndColorViewCell: UICollectionViewCell {

    // MARK: - Public Properties

    let cellUIView = UIView()
    let contentUILabel = UILabel()

    // MARK: - Initializers

    private func setupCellUIView() {
        contentView.addSubview(cellUIView)
        cellUIView.translatesAutoresizingMaskIntoConstraints = false

        cellUIView.layer.cornerRadius = 8
        cellUIView.layer.masksToBounds = true

        cellUIView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        cellUIView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        cellUIView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cellUIView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    private func setupContentUILabel() {
        cellUIView.addSubview(contentUILabel)
        contentUILabel.translatesAutoresizingMaskIntoConstraints = false

        contentUILabel.textAlignment = .center
        contentUILabel.font = .boldSystemFont(ofSize: 32)

        contentUILabel.layer.masksToBounds = true
        contentUILabel.layer.cornerRadius = 8
        contentUILabel.layer.masksToBounds = true

        contentUILabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        contentUILabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        contentUILabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentUILabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCellUIView()
        setupContentUILabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
