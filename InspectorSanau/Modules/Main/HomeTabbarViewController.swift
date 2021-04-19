//
//  HomeTabBarViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class HomeTabBarController: UITabBarController {

    // MARK: - Object live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}


// MARK: - Setup

private extension HomeTabBarController {
    func setupTabBar() {
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor(named: "ValidationBackgroundF")
        tabBar.barTintColor = UIColor(named: "BackViewColor")
        tabBar.tintColor = UIColor(named: "TextColor3")
    }
}

