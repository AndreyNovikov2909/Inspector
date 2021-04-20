//
//  HomeCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return homeViewController
    }
    
    private let navigationController: UINavigationController
    private let homeViewController: HomeViewController
    private let dispose = DisposeBag()
    private let state: SearchState
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController, state: SearchState) {
        self.navigationController = navigationController
        self.homeViewController = UIStoryboard.loadViewController()
        self.state = state
    }
    
    
    override func start() {
        switch state {
        case .city:
            navigationController.setViewControllers([homeViewController], animated: false)
        case .district:
            navigationController.pushViewController(homeViewController, animated: true)
        case .done:
            navigationController.pushViewController(homeViewController, animated: true)
        }
        
        homeViewController.builder = { input in
            let viewModel = HomeViewViewModel(input: input,
                                              httpService: HTTPManager(),
                                              realmService: try! RealmService(),
                                              state: self.state)
            
            viewModel
                .routing
                .showDetail
                .map({ self.showDetail(withSearchState: self.state, homeDetail: $0) })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
    }
}

// MARK: - Routing

private extension HomeCoordinator {
    func showDetail(withSearchState searchState: SearchState, homeDetail: HomeDetailWrapped) {
        switch state {
        case .city:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController, state: .district(city: homeDetail.title))
            homeCoordinator.start()
            homeCoordinator.add(homeCoordinator)
        case .district(let city):
            let homeCoordinator = HomeCoordinator(navigationController: navigationController, state: .done(city: city, district: homeDetail.title))
            homeCoordinator.start()
            homeCoordinator.add(homeCoordinator)
        case .done:
            let mainDescriptionCoordinator = MainDescriptionCoordinator(navigationController: navigationController,
                                                                    item: BluetoothWapped(name: homeDetail.originalName))
            mainDescriptionCoordinator.start()
            add(mainDescriptionCoordinator)
        }
    }
}
