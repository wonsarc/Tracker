//
//  CreateEventAndHabbitFactoryExtensions.swift
//  Tracker
//
//  Created by Artem Krasnov on 17.04.2024.
//

import UIKit

protocol CreateTrackerExtensionsDelegate: AnyObject {
    func didCreateNewTracker()
}

extension UIViewController {

    func scrollUIViewFactory() -> UIScrollView {

        let scrollUIViewFactory = UIScrollView()
        scrollUIViewFactory.translatesAutoresizingMaskIntoConstraints = false
        scrollUIViewFactory.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollUIViewFactory.alwaysBounceVertical = true
        scrollUIViewFactory.showsHorizontalScrollIndicator = false

        return scrollUIViewFactory
    }

    func textFieldFactory(withPlaceholder placeholder: String) -> UITextField {
        let nameTrackerTextField = UITextField()
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.textColor = .black
        nameTrackerTextField.borderStyle = .none
        nameTrackerTextField.layer.cornerRadius = 16
        nameTrackerTextField.backgroundColor = .customGray
        nameTrackerTextField.clearButtonMode = .always

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        nameTrackerTextField.leftView = leftView
        nameTrackerTextField.leftViewMode = .always

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .paragraphStyle: paragraphStyle
        ]

        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        nameTrackerTextField.attributedPlaceholder = attributedPlaceholder

        return nameTrackerTextField
    }

    func titleLabelFactory(withText text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = text

        return titleLabel
    }

    func settingsTableViewFactory() -> UITableView {
        let settingsTableView = UITableView()
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.tableFooterView = UIView(frame: .zero)
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.masksToBounds = true
        settingsTableView.isScrollEnabled = false

        return settingsTableView
    }

    func emojiAndColorCollectionViewFactory() -> UICollectionView {
        let emojiAndColorCollectionViewFactory = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        emojiAndColorCollectionViewFactory.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionViewFactory.isScrollEnabled = false

        return emojiAndColorCollectionViewFactory
    }

    func cancelButtonFactory(target: Any?, action: Selector) -> UIButton {

        let canceledButton = UIButton.systemButton(
            with: UIImage(),
            target: target,
            action: action
        )

        canceledButton.translatesAutoresizingMaskIntoConstraints = false
        canceledButton.accessibilityIdentifier = "canceledButton"
        canceledButton.setTitle(
            NSLocalizedString("extensionUIVC.canceledButton.title.text", comment: ""),
            for: .normal
        )
        canceledButton.layer.borderWidth = 1
        canceledButton.layer.borderColor = UIColor.red.cgColor
        canceledButton.tintColor = .red
        canceledButton.titleLabel?.font = .systemFont(ofSize: 16)
        canceledButton.layer.cornerRadius = 16

        return canceledButton
     }

    func createdButtonFactory(target: Any?, action: Selector) -> UIButton {

        let createdButton = UIButton.systemButton(
            with: UIImage(),
            target: target,
            action: action
        )

        createdButton.translatesAutoresizingMaskIntoConstraints = false
        createdButton.accessibilityIdentifier = "createdButton"
        createdButton.setTitle(
            NSLocalizedString("extensionUIVC.createdButton.title.text", comment: ""),
            for: .normal
        )
        createdButton.tintColor = .white
        createdButton.titleLabel?.font = .systemFont(ofSize: 16)
        createdButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        createdButton.layer.cornerRadius = 16
        createdButton.isEnabled = false

        return createdButton
     }

    func limitUILabelFactory(withText text: String) -> UILabel {

        let limitUILabel = UILabel()
        limitUILabel.translatesAutoresizingMaskIntoConstraints = false
        limitUILabel.textColor = .red
        limitUILabel.font = .systemFont(ofSize: 17)
        limitUILabel.textAlignment = .center
        limitUILabel.text = text
        limitUILabel.isHidden = true

        return limitUILabel
     }
}
