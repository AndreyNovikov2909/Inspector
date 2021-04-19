//
//  FavoriteCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift

class SearchDeviceCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return searchDeviceViewController
    }
    
    private let navigationController: UINavigationController
    private let searchDeviceViewController: SearchDeviceViewController
    private let dispose = DisposeBag()
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.searchDeviceViewController = UIStoryboard.loadViewController()
        
    }
    
    override func start() {
        navigationController.setViewControllers([searchDeviceViewController], animated: false)
        
        searchDeviceViewController.builder = { input in
            let viewModel = SearchDeviceViewModel(input: input, bluetoothManager: BluetoothManager())
            
            viewModel
                .routing
                .showCounterDetail
                .map({ self.showCounterDetail(item: $0) })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
    }
}


// MARK: - Routing

private extension SearchDeviceCoordinator {
    func showCounterDetail(item: BluetoothWapped) {
        let mainDescriptionCoordinator = MainDescriptionCoordinator(navigationController: navigationController, item: item)
        mainDescriptionCoordinator.start()
        print(item)
        add(mainDescriptionCoordinator)
    }
}
