//
//  SplashViewController.swift
//  Tracker
//
//  Created by Artem Krasnov on 09.03.2024.
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let viewController = AppSettings.isFirstOpen ? OnboardingViewController() : TabBarController()
        setRootViewController(viewController)
    }

    // MARK: - Private Methods
    private func setRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = viewController
    }
}
