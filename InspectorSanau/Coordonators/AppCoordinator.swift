//
//  AppCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class AppCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return navigationController
    }
    
    // MARK: - Private properties
    
    private let window: UIWindow?
    private var navigationController: UINavigationController =  {
        let navigationController = UINavigationController()
        navigationController.navigationBar.barTintColor = K.Colors.navigationColor
        return navigationController
    }()
    
    
    // MARK: - Object livecycle
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        

        
        if DefaultsService.shared.isAuth() {
            let mainTabBarCoordinator = HomeTabCoordinator(navigationController: navigationController)
            add(mainTabBarCoordinator)
            mainTabBarCoordinator.start()
            
        } else {
            let loginCoordinator = LoginViewCoordinator(navigationController: navigationController)
            add(loginCoordinator)
            loginCoordinator.start()
        }
    }
}
