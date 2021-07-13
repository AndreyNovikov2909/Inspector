//
//  DescriptionCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit


class DescriptionCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return descriptionViewControlller
    }
    
    private let descriptionViewControlller: DescriptionViewController
    private let bluetoothId: String
    
    init(bluetoothId: String) {
        self.descriptionViewControlller = UIStoryboard.loadViewController()
        self.bluetoothId = bluetoothId
    }
    
    override func start() {
        descriptionViewControlller.builder = { input in
            let viewModel = DescriptionViewModel(input: input, realmService: try! RealmService(), httpService: HTTPManager(), id: self.bluetoothId)
            return viewModel
        }
    }
}
