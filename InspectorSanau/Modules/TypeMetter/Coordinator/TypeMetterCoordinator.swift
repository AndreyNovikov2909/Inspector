//
//  TypeMetterCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import UIKit
import RxSwift
import RxCocoa

class TypeMetterCoordinator: BaseCoodinator {
    override var rootViewController: UIViewController {
        return typeMetterViewController
    }
    
    private let navigationController: UINavigationController
    private let typeMetterViewController: TypeMetterViewController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.typeMetterViewController = UIStoryboard.loadViewController()
    }
    
    override func start() {
        navigationController.pushViewController(typeMetterViewController, animated: true)
        
        typeMetterViewController.builder = { input in
            let  viewModel = TypeMetterViewModel(input: input)
            return viewModel
        }
    }
}
