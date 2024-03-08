//
//  LauchViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class LauchViewController: UIViewController {
    // MARK: - Private Properties
    private let backgroundColor = UIColor(red: 55.0/255.0, green: 114.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "Logo")
        return logoImageView
    }()

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(logoImageView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
