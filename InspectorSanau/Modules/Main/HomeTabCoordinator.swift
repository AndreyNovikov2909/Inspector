//
//  HomeTabCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class HomeTabCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return homeTabBarViewController
    }
    
    private let homeTabBarViewController: HomeTabBarController
    private let navigationController: UINavigationController
    
    // MARK: - Roots
    
    private var tabBarCoordinators: [Coordinator] = []
    private var viewControllers: [UIViewController] = []
    
    private let homeNavigation: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    private let favoriteNavigation: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    private let settingsNavigation: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeTabBarViewController = HomeTabBarController()
    }
    
    override func start() {
        setupTabCoordinators()
        let isAnimation = !DefaultsService.shared.isAuth()
       
        homeTabBarViewController.modalPresentationStyle = .fullScreen
        navigationController.present(homeTabBarViewController, animated: isAnimation, completion: nil)
    }
}

// MARK: - Setup coordinators

private extension HomeTabCoordinator {
    func setupTabCoordinators() {
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigation)
        let favoriteCoordinator = SearchDeviceCoordinator(navigationController: favoriteNavigation)
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavigation)
        
        tabBarCoordinators.append(homeCoordinator)
        tabBarCoordinators.append(favoriteCoordinator)
        tabBarCoordinators.append(settingsCoordinator)
        viewControllers = tabBarCoordinators.map({ $0.rootViewController })
        tabBarCoordinators.forEach({ $0.start() })
        
        homeTabBarViewController.viewControllers = [
            generateViewController(withRootVC: homeCoordinator.rootViewController, navigationTitle: "", tabBarImage: UIImage(named: "image1"), navigation: homeNavigation),
            generateViewController(withRootVC: favoriteCoordinator.rootViewController, navigationTitle: "", tabBarImage: UIImage(named: "image2"), navigation: favoriteNavigation),
            generateViewController(withRootVC: settingsCoordinator.rootViewController, navigationTitle: "", tabBarImage: UIImage(named: "image4"), navigation: settingsNavigation)
        ]
    }
    
    
    func generateViewController(withRootVC rootVC: UIViewController,
                                        navigationTitle: String,
                                        tabBarImage: UIImage?, navigation: UINavigationController) -> UIViewController {
        
        navigation.navigationItem.title = navigationTitle
        navigation.tabBarItem.image = tabBarImage
        return navigation
    }
}
