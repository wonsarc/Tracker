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

final class CategoryViewController: UIViewController {

    // MARK: - Public Properties

    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties

    private var categoryData: [String] = []
    private var viewModel: CategoryViewModel

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = L10n.Localizable.CategoryVC.TitleLabel.text

        return titleLabel
    }()

    private lazy var emptyTaskImageView: UIImageView = {
        let emptyTaskImageView = UIImageView()
        emptyTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskImageView.image = Asset.emptyTasks.image
        return emptyTaskImageView
    }()

    private lazy var emptyTaskLabel: UILabel = {
        let emptyTaskLabel = UILabel()
        emptyTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTaskLabel.text = L10n.Localizable.CategoryVC.EmptyTaskLabel.text
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
        addCategoryButton.setTitle(L10n.Localizable.CategoryVC.AddCategoryButton.text, for: .normal)
        addCategoryButton.tintColor = .white
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16)
        addCategoryButton.backgroundColor = .black
        addCategoryButton.layer.cornerRadius = 16

        return addCategoryButton
    }()

    // MARK: - Initializers

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupTitleLabel()
        setupEmptyScreen()
        setupCategoryTableView()
        setupAddCategoryButton()

        viewModel.fetchCategories()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategories()
        updateUI()
    }

    // MARK: - Private Methods

    private func bind() {
        viewModel.categories = { [weak self] categories in
            self?.categoryData = categories
            self?.updateUI()
        }
    }

    private func getHeightTableView() -> CGFloat {
        let height = CGFloat(categoryData.count) * 75

        let limitHeight = view.frame.size.height
        - titleLabel.frame.size.height - 16
        - addCategoryButton.frame.size.height - 148

        return height > limitHeight ? limitHeight : height
    }

    private func setupHeightCategoryTableView(with height: CGFloat) {

        categoryTableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = height
            }
        }
    }

    private func updateUI() {

        let isEmpty = categoryData.count < 2

        emptyTaskLabel.isHidden = !isEmpty
        emptyTaskImageView.isHidden = !isEmpty
        categoryTableView.isHidden = isEmpty

        let height = getHeightTableView()
        setupHeightCategoryTableView(with: height)
        categoryTableView.reloadData()
     }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupAddCategoryButton() {
        view.addSubview(addCategoryButton)

        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupEmptyScreen() {
        view.addSubview(emptyTaskLabel)
        view.addSubview(emptyTaskImageView)

        NSLayoutConstraint.activate([

            emptyTaskImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyTaskImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            emptyTaskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyTaskLabel.heightAnchor.constraint(equalToConstant: 36),
            emptyTaskLabel.topAnchor.constraint(equalTo: emptyTaskImageView.bottomAnchor, constant: 8),
            emptyTaskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupCategoryTableView() {
        view.addSubview(categoryTableView)

        NSLayoutConstraint.activate([
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryTableView.heightAnchor.constraint(equalToConstant: getHeightTableView())
        ])
    }

    @objc private func didTapAddCategoryButton() {
        present(NewCategoryViewController(), animated: true)
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

         let title = categoryData[indexPath.row + 1]
            cell.textLabel?.text = title

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count - 1
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {

             let cornerRadius: CGFloat = 10.0
             let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                         byRoundingCorners: [.bottomLeft, .bottomRight],
                                         cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
             let maskLayer = CAShapeLayer()
             maskLayer.path = maskPath.cgPath
             cell.layer.mask = maskLayer

             cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
         } else {
             cell.layer.mask = nil
             cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
         }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        let selectedCategory = categoryData[indexPath.row + 1]
        delegate?.didSelectCategory(selectedCategory)
        dismiss(animated: true, completion: nil)
    }
}
