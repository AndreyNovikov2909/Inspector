//
//  ChangePasswordCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import UIKit
import RxSwift

class ChangePasswordCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return changePasswordViewController
    }
    
    // MARK: - Private properties
    
    private let navigationController: UINavigationController
    private let changePasswordViewController: ChangePasswordViewController
    private let dispose = DisposeBag()
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.changePasswordViewController = UIStoryboard.loadViewController()
    }
    
    override func start() {
        changePasswordViewController.builder = { input in
            let viewModel = ChangePasswordViewModel(input: input, httpManager: HTTPManager())
            
            viewModel
                .routing
                .dismissToSettings
                .map({ self.showSettings() })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showError
                .map({ self.showError($0) })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showChangeEmail
                .map({ self.showChangePassword() })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .viewDidDisappear
                .map({ self.viewDidDisapear() })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
        
        navigationController.pushViewController(changePasswordViewController, animated: true)
    }
}


// MARK: - Routing
 
private extension ChangePasswordCoordinator {
    func showSettings() {
        changePasswordViewController.tabBarController?.singlerAlert(title: "Проверьте почту",
                                                                    description: "Отправили инструкцию для восстановления пароля",
                                                                    buttonTitle: "Понятно",
                                                                    delegate: self)
    }
    
    func showError(_ error: Error) {
        changePasswordViewController.tabBarController?.singlerAlert(title: "Ошибка",
                                                  description: error.localizedDescription,
                                                  buttonTitle: "Понятно")
    }
    
    func showChangePassword() {
        let resetEmailCoordinator = ResetEmailCoordinator(navigationController: navigationController)
        resetEmailCoordinator.start()
        add(resetEmailCoordinator)
    }
    
    func viewDidDisapear() {
        remove(self)
    }
}

// MARK: - SingleSanauAlertDelegate

extension ChangePasswordCoordinator: SingleSanauAlertDelegate {
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didOkButtonTapped okButton: UIButton) {
        sanauAlertController.animateOut {
            self.navigationController.popViewController(animated: true)
            self.remove(self)
        }
    }
    
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didTapGestureTappeed tapGesture: UITapGestureRecognizer) {
        sanauAlertController.animateOut {
            self.navigationController.popViewController(animated: true)
            self.remove(self)
        }
    }
}
