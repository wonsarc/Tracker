//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Artem Krasnov on 07.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        createLauchScreen(windowScene: windowScene)
    }
}

extension SceneDelegate {
    func createLauchScreen(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        let launchScreenVC = LauchViewController()
        window.rootViewController = launchScreenVC
        self.window = window
        window.makeKeyAndVisible()
    }
}
