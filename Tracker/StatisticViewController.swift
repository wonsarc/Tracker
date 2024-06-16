//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class StatisticViewController: UIViewController {

    // MARK: - Private Properties

    private let trackerRecordStore = TrackerRecordStore()

    private var count: Int?

    private lazy var mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel()
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = NSLocalizedString("tabBar.tab_stats", comment: "")
        mainTitleLabel.textColor = Colors.shared.buttonColor
        mainTitleLabel.font = .boldSystemFont(ofSize: 34)

        return mainTitleLabel
    }()

    private lazy var emptyImageView: UIImageView = {
        let emptyImageView = UIImageView()
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.image = UIImage(named: "emptyImage")

        return emptyImageView
    }()

    private lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.font = .systemFont(ofSize: 12)
        emptyLabel.text = NSLocalizedString("statisticVC.emptyLabel.text", comment: "")

        return emptyLabel
    }()

    private lazy var statsTableView: UITableView = {
        let statsTableView = UITableView()
        statsTableView.translatesAutoresizingMaskIntoConstraints = false

        statsTableView.register(
            StatsViewCell.self,
            forCellReuseIdentifier: IdentityCellEnum.statsViewCell.rawValue
        )
        statsTableView.rowHeight = 90
        statsTableView.isScrollEnabled = false
        statsTableView.dataSource = self
        statsTableView.delegate = self

        return statsTableView
    }()

    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(mainTitleLabel)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        view.addSubview(statsTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),

            statsTableView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 77),
            statsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupScreen() {
        count = trackerRecordStore.countFetch()

        let isEmpty = count ?? 0 > 0

        statsTableView.reloadData()

        emptyImageView.isHidden = isEmpty
        emptyLabel.isHidden = isEmpty
        statsTableView.isHidden = !isEmpty
    }
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let count = count,
              count > 0 else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: IdentityCellEnum.statsViewCell.rawValue
        ) as? StatsViewCell

        guard let cell = cell else { return UITableViewCell() }

        cell.countCellLabel.text = "\(count)"

        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {}
