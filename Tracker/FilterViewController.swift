//
//  FilterViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 12.06.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: FilterModel)
}

final class FilterViewController: UIViewController {

    // MARK: - Public Properties

    var currentFilter: FilterModel
    weak var delegate: FilterViewControllerDelegate?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString(
            "trackersVC.filterButton.title",
            comment: "")

        return titleLabel
    }()

    // MARK: - Initializers

    init(currentFilter: FilterModel) {
        self.currentFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private lazy var filterTableView: UITableView = {
        let filterTableView = UITableView()
        filterTableView.translatesAutoresizingMaskIntoConstraints = false
        filterTableView.register(
            FilterViewCell.self,
            forCellReuseIdentifier: IdentityCellEnum.filterViewCell.rawValue
        )
        filterTableView.tableFooterView = UIView(frame: .zero)
        filterTableView.layer.cornerRadius = 16
        filterTableView.rowHeight = 75
        filterTableView.isScrollEnabled = false
        filterTableView.layer.masksToBounds = true
        filterTableView.dataSource = self
        filterTableView.delegate = self

        return filterTableView
    }()

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        setupTitleLabel()
        setupFilterTableView()
    }

    // MARK: - Private Methods

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupFilterTableView() {
        view.addSubview(filterTableView)

        NSLayoutConstraint.activate([
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            filterTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.filterViewCell.rawValue
        ) as? FilterViewCell

        guard let cell = cell else { return UITableViewCell()}

        if indexPath.row == currentFilter.index {
            cell.accessoryType = .checkmark
        }

        cell.textLabel?.text = FilterModel.fromIndex(indexPath.row)?.localizedString

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        delegate?.didSelectFilter(FilterModel.fromIndex(indexPath.row) ?? .all)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {

}
