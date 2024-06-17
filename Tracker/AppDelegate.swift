//
//  AppDelegate.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.03.2024.
//

import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow()
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()

        if AppSettings.isFirstOpen {
            TrackerCategoryStore().createRecord(with: AppSettings.pinCategoryName)
        }

        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "API_KEY") else {
            return true
        }

        YMMYandexMetrica.activate(with: configuration)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}
