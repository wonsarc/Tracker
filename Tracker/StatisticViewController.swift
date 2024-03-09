//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = "Статистика"
        mainTitleLabel.textColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        mainTitleLabel.font = .boldSystemFont(ofSize: 34)
        return mainTitleLabel
    }()

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(mainTitleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
}
