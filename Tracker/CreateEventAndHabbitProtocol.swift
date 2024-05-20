//
//  CreateEventAndHabbitViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 19.04.2024.
//

import UIKit

protocol CreateEventAndHabbitProtocol: AnyObject {
    var titleLabel: UILabel { get }
    var scrollView: UIScrollView { get }
    var nameTrackerTextField: UITextField { get }
    var limitUILabel: UILabel { get }
    var settingsTableView: UITableView { get }
    var emojiAndColorCollectionView: UICollectionView { get }
    var canceledButton: UIButton { get }
    var createdButton: UIButton { get }
    var detailTextLabel: String { get set }
    var isHeaderVisible: Bool { get set }
    var trackerStore: TrackerStore { get }

    func setupViews()
    func setupConstraints()
    func createTextFieldCheckAction(_ textField: UITextField)
    func createButtonAction(with newTracker: TrackerModel)
    func cancelButtonAction()
    func createCategoryVC() -> CategoryViewController
}

extension CreateEventAndHabbitProtocol where Self: UIViewController {

    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(nameTrackerTextField)
        scrollView.addSubview(settingsTableView)
        scrollView.addSubview(emojiAndColorCollectionView)
        scrollView.addSubview(canceledButton)
        scrollView.addSubview(createdButton)
    }

    func setupConstraints() {

        let topAnchor: CGFloat = !isHeaderVisible ? 0 : 24

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nameTrackerTextField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            settingsTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: topAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: 200),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emojiAndColorCollectionView.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 8),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 525),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            canceledButton.widthAnchor.constraint(equalToConstant: 166),
            canceledButton.heightAnchor.constraint(equalToConstant: 60),
            canceledButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            canceledButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: -16),

            createdButton.widthAnchor.constraint(equalToConstant: 161),
            createdButton.heightAnchor.constraint(equalToConstant: 60),
            createdButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createdButton.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: -16)
        ])
    }

    func createTextFieldCheckAction(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 38 {
            textField.deleteBackward()
            isHeaderVisible = true
        } else {
            isHeaderVisible = false
        }

        settingsTableView.reloadData()
        limitUILabel.isHidden = !isHeaderVisible
        createdButton.isEnabled = !isHeaderVisible

    }

    func cancelButtonAction() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func createButtonAction(with newTracker: TrackerModel) {

        try? trackerStore.addRecord(newTracker, toCategoryWithName: detailTextLabel)
        trackerStore.refreshFetchResults()

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }

    func createCategoryVC() -> CategoryViewController {
        let categoryModel = CategoryModel()
        let viewModel = CategoryViewModel(for: categoryModel)

        return CategoryViewController(viewModel: viewModel)
    }
}
