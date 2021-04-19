//
//  HomeCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class HomeCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return homeViewController
    }
    
    private let navigationController: UINavigationController
    private let homeViewController: HomeViewController

    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
        
    }
    
    
    override func start() {
        navigationController.setViewControllers([homeViewController], animated: false)
    }
}
