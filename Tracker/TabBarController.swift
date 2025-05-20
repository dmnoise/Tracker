//
//  TabBarController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trakcerVC = UINavigationController(rootViewController: TrackerViewController())
        let statsVC = UINavigationController(rootViewController: StatsViewController())
        
        let tabBatItemTracker = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .tracker),
            selectedImage: nil
        )
        
        let tabBatItemStats = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .stats),
            selectedImage: nil
        )
        
        trakcerVC.tabBarItem = tabBatItemTracker
        statsVC.tabBarItem = tabBatItemStats
        
        self.viewControllers = [trakcerVC, statsVC]
    }
}
