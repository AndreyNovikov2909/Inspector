//
//  LoginViewCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return loginViewController
    }
    
    // MARK: - Private propties
    
    private let navigationController: UINavigationController
    private let dispose = DisposeBag()
    private let loginViewController: LoginViewController
    
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        loginViewController = UIStoryboard.loadViewController()
    }
    
    
    // MARK: - Object livecycle
    
    override func start() {
        loginViewController.builder = { input in
            let viewModel = LoginViewViewModel(input: input, validator: Validation.shared)
            
            viewModel
                .routing
                .showChangeEmail
                .map({ self.showChangeEmail() })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showMain
                .map({ self.showMainTab() })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showError
                .map({ self.showError(error: $0) })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
        
        navigationController.setViewControllers([loginViewController], animated: true)
    }
}

// MARK: - Routing

private extension LoginViewCoordinator {
    func showChangeEmail() {
        let changeEmailCoordinator = ResetEmailCoordinator(navigationController: navigationController)
        add(changeEmailCoordinator)
        changeEmailCoordinator.start()
    }
    
    func showMainTab() {
        let homeTabCoordinator = HomeTabCoordinator(navigationController: navigationController)
        DefaultsService.shared.setAuth(value: true)
        add(homeTabCoordinator)
        homeTabCoordinator.start()
    }
    
    func showError(error: Error) {
        rootViewController.singlerAlert(title: "Ошибка", description: error.localizedDescription)
    }
}
