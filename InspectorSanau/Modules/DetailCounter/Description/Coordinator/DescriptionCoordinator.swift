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
    
    
    override init() {
        self.descriptionViewControlller = UIStoryboard.loadViewController()
    }
    
    override func start() {
        descriptionViewControlller.builder = { input in
            let viewModel = DescriptionViewModel(input: input, realmService: try! RealmService(), httpService: HTTPManager())
            return viewModel
        }
    }
}
