//
//  CreateHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 31.03.2024.
//

import UIKit

final class CreateHabbitViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = "Новая привычка"
        
        return titleLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let nameTrackerTextField = UITextField()
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.placeholder = "Введите название трекера"
        nameTrackerTextField.textColor = .black
        nameTrackerTextField.borderStyle = .roundedRect
        nameTrackerTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        nameTrackerTextField.clearButtonMode = .always
        
        return nameTrackerTextField
    }()
    
    private lazy var settingsTableView: UITableView = {
        let settingsTableView = UITableView()
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.register(CreateHabbitViewSettingsCell.self, forCellReuseIdentifier: "cell")
        settingsTableView.tableFooterView = UIView(frame: .zero)
        settingsTableView.rowHeight = 75
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.masksToBounds = true
        settingsTableView.dataSource = self
        
        return settingsTableView
    }()
    
    private lazy var canceledButton: UIButton = {
        let canceledButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateHabbitButton)
        )
        
        canceledButton.translatesAutoresizingMaskIntoConstraints = false
        canceledButton.accessibilityIdentifier = "canceledButton"
        canceledButton.setTitle("Отменить", for: .normal)
        canceledButton.layer.borderWidth = 1
        canceledButton.layer.borderColor = UIColor.red.cgColor
        canceledButton.tintColor = .red
        canceledButton.titleLabel?.font = .systemFont(ofSize: 16)
        canceledButton.layer.cornerRadius = 16
        
        return canceledButton
    }()
    
    private lazy var createdButton: UIButton = {
        let createdButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapCreateHabbitButton)
        )
        
        createdButton.translatesAutoresizingMaskIntoConstraints = false
        createdButton.accessibilityIdentifier = "createdButton"
        createdButton.setTitle("Создать", for: .normal)
        createdButton.tintColor = .white
        createdButton.titleLabel?.font = .systemFont(ofSize: 16)
        createdButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        createdButton.layer.cornerRadius = 16
        
        return createdButton
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
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(settingsTableView)
        view.addSubview(canceledButton)
        view.addSubview(createdButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            settingsTableView.heightAnchor.constraint(equalToConstant: 150),
            settingsTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            canceledButton.widthAnchor.constraint(equalToConstant: 166),
            canceledButton.heightAnchor.constraint(equalToConstant: 60),
            canceledButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            canceledButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createdButton.widthAnchor.constraint(equalToConstant: 166),
            createdButton.heightAnchor.constraint(equalToConstant: 60),
            createdButton.leadingAnchor.constraint(equalTo: canceledButton.trailingAnchor, constant: 8),
            createdButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
    }
}

// MARK: - UITableViewDataSource

extension CreateHabbitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CreateHabbitViewSettingsCell
        
        guard let cell = cell else { return UITableViewCell()}
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
        } else {
            cell.textLabel?.text = "Расписание"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
