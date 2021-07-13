//
//  ResetEmailCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift

class ResetEmailCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return resetEmailViewController
    }
    
    // MARK: - Private proprties
    
    private let navigationController: UINavigationController
    private let resetEmailViewController: ResetEmailViewController
    private let dispose = DisposeBag()
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.resetEmailViewController = UIStoryboard.loadViewController()
    }
    
    override func start() {
        resetEmailViewController.builder = { input in
            let viewModel = ResetEmailViewModel(input: input)
            viewModel
                .routing
                .dismissSelf.map({ self.remove(self) })
                .drive()
                .disposed(by: self.dispose)
            
            viewModel
                .routing
                .showAlert
                .map({ self.showAlert(result: $0) })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
        
        navigationController.pushViewController(resetEmailViewController, animated: true)
    }
}

// MARK: - Routing

private extension ResetEmailCoordinator {
    func showAlert(result: Result<Void, Error>) {
        switch result {
        case .success():
            if let tabBarVC = rootViewController.tabBarController {
                tabBarVC.singlerAlert(title: "Проверьте почту",
                                      description: "Cсылка на ввод нового пароля отправлена на почту",
                                      buttonTitle: "Понятно",
                                      delegate: self)
                return
            }
            
            rootViewController.singlerAlert(title: "Проверьте почту",
                                            description: "Cсылка на ввод нового пароля отправлена на почту",
                                            buttonTitle: "Понятно",
                                            delegate: self)
            
        case .failure(let error):
            if let tabBarVC = rootViewController.tabBarController {
                tabBarVC.singlerAlert(title: "Ошибка",
                                      description: error.localizedDescription,
                                      buttonTitle: "Понятно")
                return
            }
            
            rootViewController.singlerAlert(title: "Ошибка",
                                            description: error.localizedDescription,
                                            buttonTitle: "Понятно")
        }
    }
}

// MARK: - SingleSanauAlertDelegate

extension ResetEmailCoordinator: SingleSanauAlertDelegate {
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didOkButtonTapped okButton: UIButton) {
        sanauAlertController.animateOut {
            self.navigationController.popToRootViewController(animated: true)
            self.remove(self)
        }
    }
    
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didTapGestureTappeed tapGesture: UITapGestureRecognizer) {
        sanauAlertController.animateOut {
                self.navigationController.popToRootViewController(animated: true)
                self.remove(self)
            }
    }
}
