//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.04.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

final class CategoryViewController: UIViewController, NewCategoryViewControllerDelegate {

    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties

    private var categoryData =  DataManager.shared.category

    private lazy var titleLabel: UILabel = {
        let titleLabel = self.titleLabelFactory(withText: "Категория")
        return titleLabel
    }()

    private lazy var emptyTaskImageView: UIImageView = {
        let emptyTaskImageView = UIImageView()
        emptyTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskImageView.image = UIImage(named: "empty_tasks")
        return emptyTaskImageView
    }()

    private lazy var emptyTaskLabel: UILabel = {
        let emptyTaskLabel = UILabel()
        emptyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskLabel.text = "Привычки и события можно\nобъединить по смыслу"
        emptyTaskLabel.textColor = .black
        emptyTaskLabel.numberOfLines = 2
        emptyTaskLabel.font = .systemFont(ofSize: 12)
        emptyTaskLabel.textAlignment = .center
        return emptyTaskLabel
    }()

    private lazy var categoryTableView: UITableView = {
        let categoryTableView = UITableView()
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.register(
            CategoryViewCell.self,
            forCellReuseIdentifier: IdentityCellEnum.categoryViewCell.rawValue
        )
        categoryTableView.tableFooterView = UIView(frame: .zero)
        categoryTableView.rowHeight = 75
        categoryTableView.layer.cornerRadius = 16
        categoryTableView.layer.masksToBounds = true
        categoryTableView.dataSource = self
        categoryTableView.delegate = self

        return categoryTableView
    }()

    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapAddCategoryButton)
        )

        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.accessibilityIdentifier = "addCategoryButton"
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.tintColor = .white
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16)
        addCategoryButton.backgroundColor = .black
        addCategoryButton.layer.cornerRadius = 16

        return addCategoryButton
    }()

    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()

    }

    func addCategory() {
        categoryData = DataManager.shared.category
        view.subviews.forEach { $0.removeFromSuperview() }
        setupViews()
        setupConstraints()
        categoryTableView.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(titleLabel)

        if categoryData.isEmpty {
            view.addSubview(emptyTaskImageView)
            view.addSubview(emptyTaskLabel)
        } else {
            view.addSubview(categoryTableView)
        }

        view.addSubview(addCategoryButton)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        if categoryData.isEmpty {
            NSLayoutConstraint.activate([
                emptyTaskImageView.widthAnchor.constraint(equalToConstant: 80),
                emptyTaskImageView.heightAnchor.constraint(equalToConstant: 80),
                emptyTaskImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
                emptyTaskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                emptyTaskLabel.heightAnchor.constraint(equalToConstant: 36),
                emptyTaskLabel.topAnchor.constraint(equalTo: emptyTaskImageView.bottomAnchor, constant: 8),
                emptyTaskLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                emptyTaskLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint.activate([
                categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                categoryTableView.heightAnchor.constraint(equalToConstant: 150)
            ])
        }
    }

    @objc private func didTapAddCategoryButton() {
        let viewController = NewCategoryViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.categoryViewCell.rawValue
        ) as? CategoryViewCell

        guard let cell = cell else { return UITableViewCell()}

        if let title = categoryData[indexPath.row].title {
            cell.textLabel?.text = title
        }

        if indexPath == DataManager.shared.selectCategoryItem {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        let selectedCategory = categoryData[indexPath.row].title ?? ""
        delegate?.didSelectCategory(selectedCategory)
        DataManager.shared.selectCategoryItem = indexPath
        dismiss(animated: true, completion: nil)
    }
}
