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
        colorUIView.addInteraction(UIContextMenuInteraction(delegate: self))
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

    private lazy var pinUIView: UIView = {
        let pinUIView = UIView()
        pinUIView.translatesAutoresizingMaskIntoConstraints = false
        return pinUIView
    }()

    private lazy var pinUIImageView: UIImageView = {
        let pinUIImageView = UIImageView()
        pinUIImageView.translatesAutoresizingMaskIntoConstraints = false
        pinUIImageView.image = UIImage(named: "pin.square")
        pinUIImageView.tintColor = .white
        return pinUIImageView
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
        dateUILabel.textColor = Colors.shared.buttonColor
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
        colorUIView.addSubview(emojiColorUIView)
        colorUIView.addSubview(pinUIView)
        colorUIView.addSubview(emojiUILabel)
        colorUIView.addSubview(descriptionUILabel)
        pinUIView.addSubview(pinUIImageView)
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

            pinUIView.widthAnchor.constraint(equalToConstant: 24),
            pinUIView.heightAnchor.constraint(equalToConstant: 24),
            pinUIView.topAnchor.constraint(equalTo: colorUIView.topAnchor, constant: 12),
            pinUIView.trailingAnchor.constraint(equalTo: colorUIView.trailingAnchor, constant: -4),

            pinUIImageView.widthAnchor.constraint(equalToConstant: 8),
            pinUIImageView.heightAnchor.constraint(equalToConstant: 12),
            pinUIImageView.topAnchor.constraint(equalTo: pinUIView.topAnchor, constant: 8),
            pinUIImageView.leadingAnchor.constraint(equalTo: pinUIView.leadingAnchor, constant: 6),

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

    private func findViewController() -> UIViewController? {
          var responder: UIResponder? = self
          while responder != nil {
              responder = responder?.next
              if let viewController = responder as? UIViewController {
                  return viewController
              }
          }
          return nil
      }

    private func isPin(trackerId: UUID) -> Bool {
        guard let isPin = try? TrackerStore().getTracker(
            withId: trackerId
        )?.category?.title == AppSettings.pinCategoryName else { return false }

        return isPin
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
            let days = trackerRecordStore.countFetch(id)
            dateUILabel.text = String.localizedStringWithFormat(
                NSLocalizedString("countDays", comment: "Count done days"),
                days
            )

            pinUIImageView.isHidden = !isPin(trackerId: id)
        }

        if let id = trackerModel?.id,
           let date = currentDate {
            let isDone = trackerRecordStore.isTrackerDone(with: id, for: date)
            updateDoneButtonImage(isDone)
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension TrackerCollectionViewCell: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            guard let trackerId = self.trackerModel?.id else { return UIMenu()}
            let isPin = self.isPin(trackerId: trackerId)

            let pinAction = UIAction(title: isPin ? "Unpin" : "Pin") { _ in
                try? TrackerCategoryStore().togglePinTracker(trackerId)
            }

            let editAction = UIAction(title: "Edit") { _ in

                guard let parentViewController = self.findViewController(),
                      let schedule = try? TrackerStore().getTracker(withId: trackerId)?.schedule as? [WeekDaysModel]
                else { return }

                let type: EventAndHabbitType = schedule.isEmpty ? .event  : .habbit

                let viewController = EventAndHabbitViewController(
                    trackerId: trackerId,
                    typeScreen: type,
                    action: .edit
                )
                parentViewController.present(viewController, animated: true)
            }

            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { _ in
                self.showDeleteConfirmation(for: trackerId)
            }

            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }

    private func showDeleteConfirmation(for trackerId: UUID) {
        guard let parentViewController = self.findViewController() else { return }

        let alertController = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить трекер?",
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            TrackerStore().deleteRecord(id: trackerId)
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        parentViewController.present(alertController, animated: true, completion: nil)
    }
}
