//
//  TabBarController.swift
//  Tracker
//
//  Created by Artem Krasnov on 08.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.TrackersVC.NavigationItem.title,
            image: Asset.tabTrackers.image,
            selectedImage: nil)

        let statsViewController = StatisticViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.TabBar.tabStats,
            image: Asset.tabStats.image,
            selectedImage: nil)

        let trackerController = UINavigationController(rootViewController: trackerViewController)

        self.viewControllers = [trackerController, statsViewController]
    }
}
