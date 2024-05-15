//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.04.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addCategory()
}

final class NewCategoryViewController: UIViewController {

    weak var delegate: NewCategoryViewControllerDelegate?
    var trackerCategoryStore = TrackerCategoryStore()

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Новая категория")
        return titleLabel
    }()

    private lazy var nameCategoryTextField: UITextField = {
        let textField = self.textFieldFactory(withPlaceholder: "Введите название категории")
        return textField
    }()

    private lazy var doneButton: UIButton = {
        let doneButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapDoneButton)
        )

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.accessibilityIdentifier = "doneButton"
        doneButton.setTitle("Готово", for: .normal)
        doneButton.tintColor = .white
        doneButton.titleLabel?.font = .systemFont(ofSize: 16)
        doneButton.backgroundColor = .lightGray
        doneButton.isEnabled = false
        doneButton.layer.cornerRadius = 16

        return doneButton
    }()

    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        nameCategoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(nameCategoryTextField)
        view.addSubview(doneButton)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapDoneButton() {
        trackerCategoryStore.createRecord(with: nameCategoryTextField.text!)
        delegate?.addCategory()
        dismiss(animated: false)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateDoneButton()
    }

    private func updateDoneButton() {
            if let text = nameCategoryTextField.text, !text.isEmpty {
                doneButton.backgroundColor = .black
                doneButton.isEnabled = true
            } else {
                doneButton.backgroundColor = .lightGray
                doneButton.isEnabled = false
            }
    }
}
