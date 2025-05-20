//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let splashScreen = SplashScreen()
        splashScreen.delegate = self
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splashScreen
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: SplashScreenDelegate {
    func switchToTabBar() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
    }
}


