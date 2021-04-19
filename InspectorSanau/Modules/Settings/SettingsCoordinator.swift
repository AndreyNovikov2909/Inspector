//
//  SettingsCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift

class SettingsCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return settingsViewController
    }
    
    private let navigationController: UINavigationController
    private let settingsViewController: SettingsViewController
    private let dispose = DisposeBag()
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingsViewController = UIStoryboard.loadViewController()
        
    }
    
    override func start() {
        settingsViewController.builder = { input in
            let viewModel = SettingsViewModel(input: input, httpManager: HTTPManager(), realmService: try! RealmService())
            
            viewModel
                .routing
                .showChangePassword
                .map({
                    self.showChangePassword()
                }).drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showAuth
                .map({
                    self.showAuth()
                }).drive()
                .disposed(by: self.dispose)
            
            
            return viewModel
        }
        
        navigationController.setViewControllers([settingsViewController], animated: true)
    }
}


// MARK: - Routing

private extension SettingsCoordinator {
    func showAuth() {
        DefaultsService.shared.setAuth(value: false)
        settingsViewController.dismiss(animated: true) {
            let loginCoordinator = LoginViewCoordinator(navigationController: self.navigationController)
            self.add(loginCoordinator)
            loginCoordinator.start()
        }
        remove(self)
    }
    
    func showChangePassword() {
        let changePasswordCoordinator = ChangePasswordCoordinator(navigationController: navigationController)
        add(changePasswordCoordinator)
        changePasswordCoordinator.start()
    }
}
