//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 31.03.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = "Создание трекера"

        return titleLabel
    }()

    private lazy var createHabbitButton: UIButton = {
        let createHabbitButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateHabbitButton)
        )

        createHabbitButton.accessibilityIdentifier = "createHabbitButton"
        createHabbitButton.setTitle("Привычка", for: .normal)
        setupButton(createHabbitButton)

        return createHabbitButton
    }()

    private lazy var createEventButton: UIButton = {
        let createEventButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateHabbitButton)
        )

        createEventButton.accessibilityIdentifier = "createEventButton"
        createEventButton.setTitle("Нерегулярное событие", for: .normal)
        setupButton(createEventButton)

        return createEventButton
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
        view.addSubview(createHabbitButton)
        view.addSubview(createEventButton)
        view.addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            createHabbitButton.widthAnchor.constraint(equalToConstant: 335),
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabbitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createHabbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            createEventButton.widthAnchor.constraint(equalToConstant: 335),
            createEventButton.heightAnchor.constraint(equalToConstant: 60),
            createEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEventButton.topAnchor.constraint(equalTo: createHabbitButton.bottomAnchor, constant: 16)
        ])
    }

    private func setupButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
    }

    @objc private func didTapCreateHabbitButton() {
        present(CreateHabbitViewController(), animated: true)

    }
}
