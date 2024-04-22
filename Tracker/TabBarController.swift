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
            title: "Трекеры",
            image: UIImage(named: "tab_trackers"),
            selectedImage: nil)

        let statsViewController = StatisticViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_stats"),
            selectedImage: nil)

        let trackerController = UINavigationController(rootViewController: trackerViewController)

        self.viewControllers = [trackerController, statsViewController]
    }
}
