//
//  FilterCoordinatoe.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import UIKit
import RxSwift
import RxCocoa

class FilterCoordinatoe: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return filterViewController
    }
    
    private let navigationController: UINavigationController
    private let filterViewController: FilterViewController
    private let dispose = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.filterViewController = UIStoryboard.loadViewController()
    }
    
    override func start() {
        filterViewController.builder = { input in
            let viewModel = FilterViewModel(input: input)
            
            viewModel
                .routing
                .showDescription
                .map({
                    switch $0 {
                    case .region:
                        DefaultsService.shared.removeSearch()
                        self.showHomeView()
                    case .type:
                        self.showPhaseView()
                    }
                }).drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
        
        navigationController.pushViewController(filterViewController, animated: true)
    }
}

// MARK: - Routing

private extension FilterCoordinatoe {
    func showHomeView() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, state: .city, needSet: true)
        homeCoordinator.start()
        add(homeCoordinator)
    }
    
    func showPhaseView() {
        let typeMetterCoordinator = TypeMetterCoordinator(navigationController: navigationController)
        typeMetterCoordinator.start()
        add(typeMetterCoordinator)
    }
}
