//
//  TrackerCollectionView.swift
//  Tracker
//
//  Created by Artem Krasnov on 17.03.2024.
//

import UIKit

protocol TrackerCollectionViewCellProtocol {
    func configure(with tracker: TrackerModel, for currentDate: Date?)
}

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didTapDoneButton(for tracker: TrackerModel)
}

final class TrackerCollectionViewCell: UICollectionViewCell {

    weak var delegate: TrackerCollectionViewCellDelegate?
    var trackerModel: TrackerModel?
    var taskDate: Date?

    // MARK: - Private Properties

    private var trackerRecordStore = TrackerRecordStore()

    private lazy var cellUIView: UIView = {
        let cellUIView = UIView()
        cellUIView.translatesAutoresizingMaskIntoConstraints = false
        return cellUIView
    }()

    private lazy var colorUIView: UIView = {
        let colorUIView = UIView()
        colorUIView.translatesAutoresizingMaskIntoConstraints = false
        colorUIView.layer.cornerRadius = 16
        return colorUIView
    }()

    private lazy var emojiColorUIView: UIView = {
        let emojiColorUIView = UIView()
        emojiColorUIView.translatesAutoresizingMaskIntoConstraints = false
        emojiColorUIView.backgroundColor = .white
        emojiColorUIView.alpha = 0.3
        emojiColorUIView.layer.cornerRadius = 12
        return emojiColorUIView
    }()

    private lazy var emojiUILabel: UILabel = {
        let emojiUILabel = UILabel()
        emojiUILabel.translatesAutoresizingMaskIntoConstraints = false
        emojiUILabel.font = .systemFont(ofSize: 14)
        emojiUILabel.numberOfLines = 0
        emojiUILabel.textAlignment = .center
        return emojiUILabel
    }()

    private lazy var descriptionUILabel: UILabel = {
        let descriptionUILabel = UILabel()
        descriptionUILabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionUILabel.textColor = .white
        descriptionUILabel.font = .systemFont(ofSize: 12)
        return descriptionUILabel
    }()

    private lazy var dateUILabel: UILabel = {
        let dateUILabel = UILabel()
        dateUILabel.translatesAutoresizingMaskIntoConstraints = false
        dateUILabel.textColor = .black
        dateUILabel.font = .systemFont(ofSize: 12)
        return dateUILabel
    }()

    private lazy var doneButton: UIButton = {
        let doneButton = UIButton.systemButton(
            with: UIImage(named: "plus") ?? UIImage(),
            target: self,
            action: #selector(didTapDoneButton)
        )
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.tintColor = .white
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 17
        return doneButton
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupViews() {
        contentView.addSubview(cellUIView)
        contentView.addSubview(colorUIView)
        contentView.addSubview(emojiColorUIView)
        contentView.addSubview(emojiUILabel)
        contentView.addSubview(descriptionUILabel)
        contentView.addSubview(dateUILabel)
        contentView.addSubview(doneButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellUIView.widthAnchor.constraint(equalToConstant: 167),
            cellUIView.heightAnchor.constraint(equalToConstant: 148),
            cellUIView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellUIView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            colorUIView.widthAnchor.constraint(equalToConstant: 167),
            colorUIView.heightAnchor.constraint(equalToConstant: 90),
            colorUIView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorUIView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            emojiColorUIView.widthAnchor.constraint(equalToConstant: 24),
            emojiColorUIView.heightAnchor.constraint(equalToConstant: 24),
            emojiColorUIView.topAnchor.constraint(equalTo: colorUIView.topAnchor, constant: 12),
            emojiColorUIView.leadingAnchor.constraint(equalTo: colorUIView.leadingAnchor, constant: 12),

            emojiUILabel.widthAnchor.constraint(equalToConstant: 16),
            emojiUILabel.heightAnchor.constraint(equalToConstant: 22),
            emojiUILabel.topAnchor.constraint(equalTo: emojiColorUIView.topAnchor, constant: 1),
            emojiUILabel.leadingAnchor.constraint(equalTo: emojiColorUIView.leadingAnchor, constant: 4),

            descriptionUILabel.widthAnchor.constraint(equalToConstant: 143),
            descriptionUILabel.heightAnchor.constraint(equalToConstant: 34),
            descriptionUILabel.topAnchor.constraint(equalTo: colorUIView.topAnchor, constant: 44),
            descriptionUILabel.leadingAnchor.constraint(equalTo: colorUIView.leadingAnchor, constant: 12),

            dateUILabel.widthAnchor.constraint(equalToConstant: 101),
            dateUILabel.heightAnchor.constraint(equalToConstant: 18),
            dateUILabel.topAnchor.constraint(equalTo: colorUIView.bottomAnchor, constant: 16),
            dateUILabel.leadingAnchor.constraint(equalTo: cellUIView.leadingAnchor, constant: 12),

            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.topAnchor.constraint(equalTo: colorUIView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: cellUIView.trailingAnchor, constant: -12)
        ])
    }

    private func updateDoneButtonImage(_ isDone: Bool) {
        let imageName = isDone ? "done" : "plus"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(image, for: .normal)
    }

    @objc private func didTapDoneButton() {
        guard let trackerModel = trackerModel,
              let taskDate = taskDate else { return }

        let isDone = trackerRecordStore.isTrackerDone(with: trackerModel.id, for: taskDate)

        if isDone {
            TrackerRecordStore().deleteTrackerRecord(
                id: trackerModel.id,
                date: taskDate
            )
        } else {
            if Date() >= taskDate {
                try? TrackerRecordStore().addRecord(
                    TrackerRecordModel(
                        id: trackerModel.id,
                        date: taskDate
                    )
                )
                updateDoneButtonImage(true)
            }
        }

        delegate?.didTapDoneButton(for: trackerModel )
    }
}

// MARK: - TrackerCollectionViewCellProtocol

extension TrackerCollectionViewCell: TrackerCollectionViewCellProtocol {

    func configure(with tracker: TrackerModel, for currentDate: Date?) {
        trackerModel = tracker
        taskDate = currentDate
        descriptionUILabel.text = tracker.name
        emojiUILabel.text = tracker.emoji
        colorUIView.backgroundColor = tracker.color
        doneButton.backgroundColor = tracker.color

        if let id = trackerModel?.id {
            let days = trackerRecordStore.countFetchById(id: id)
            dateUILabel.text = String.localizedStringWithFormat(
                NSLocalizedString("countDays", comment: "Count done days"),
                days
            )
        }

        if let id = trackerModel?.id,
           let date = currentDate {
            let isDone = trackerRecordStore.isTrackerDone(with: id, for: date)
            updateDoneButtonImage(isDone)
        }
    }
}
