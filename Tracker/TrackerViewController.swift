//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = "Трекеры"
        mainTitleLabel.textColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        mainTitleLabel.font = .boldSystemFont(ofSize: 34)
        return mainTitleLabel
    }()

    private lazy var addTaskButton: UIButton = {
        let addTaskButton = UIButton.systemButton(
            with: UIImage(named: "plus") ?? UIImage(),
            target: self,
            action: #selector(didTapAddTaskButton)
        )
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.tintColor = .black
        addTaskButton.accessibilityIdentifier = "addTaskButton"
        return addTaskButton
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.accessibilityIdentifier = "searchBar"
        return searchBar
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.accessibilityIdentifier = "datePicker"
        return datePicker
    }()

    private lazy var emptyTaskLabel: UILabel = {
        let emptyTaskLabel = UILabel()
        emptyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskLabel.text = "Что будем отслеживать?"
        emptyTaskLabel.textColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        emptyTaskLabel.font = .systemFont(ofSize: 12)
        emptyTaskLabel.textAlignment = .center
        return emptyTaskLabel
    }()

    private lazy var emptyTaskImageView: UIImageView = {
        let emptyTaskImageView = UIImageView()
        emptyTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskImageView.image = UIImage(named: "empty_tasks")
        return emptyTaskImageView
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
        view.addSubview(addTaskButton)
        view.addSubview(searchBar)
        view.addSubview(datePicker)
        view.addSubview(emptyTaskLabel)
        view.addSubview(emptyTaskImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitleLabel.topAnchor.constraint(equalTo: addTaskButton.bottomAnchor, constant: 1),

            addTaskButton.widthAnchor.constraint(equalToConstant: 44),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            addTaskButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),

            searchBar.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emptyTaskLabel.heightAnchor.constraint(equalToConstant: 18),
            emptyTaskLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 318),
            emptyTaskLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyTaskLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emptyTaskImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.bottomAnchor.constraint(equalTo: emptyTaskLabel.topAnchor, constant: -8),
            emptyTaskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setDateString() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        let selectedDate = datePicker.date
        let dateString = dateFormatter.string(from: selectedDate)
    }

    @objc
    private func didTapAddTaskButton() {

    }
}
