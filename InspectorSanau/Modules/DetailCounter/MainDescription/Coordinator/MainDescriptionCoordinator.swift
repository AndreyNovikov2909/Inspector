//
//  MainDescriptionCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit

class MainDescriptionCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return mainDescriptionViewController
    }
    
    // MARK: - Private  propties
    
    private let navigationController: UINavigationController
    private let mainDescriptionViewController: MainDescriptionViewController
    private lazy var view = mainDescriptionViewController.view
    private lazy var scrollView = mainDescriptionViewController.scrollView
    
    private let bluetoothDataCoordinator: BluetoothDataCoordinator
    private lazy var descrionViewCoordinator = DescriptionCoordinator(bluetoothId: bluetoothId)
    private let item: BluetoothWapped
    private let bluetoothId: String
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController, item: BluetoothWapped, bluetoothId: String) {
        self.bluetoothId = bluetoothId
        self.navigationController = navigationController
        self.mainDescriptionViewController = UIStoryboard.loadViewController()
            
        self.item = item
        self.bluetoothDataCoordinator = BluetoothDataCoordinator(item: item, id: bluetoothId)
    
    }
    
    override func start() {
        self.mainDescriptionViewController.builder = { input in
            return MainDescriptionViewModel(input: input, id: self.bluetoothId)
        }
        print(mainDescriptionViewController.view.frame)

        
        navigationController.pushViewController(mainDescriptionViewController, animated: true)

        
        bluetoothDataCoordinator.start()
        descrionViewCoordinator.start()
        
        add(bluetoothDataCoordinator)
        add(descrionViewCoordinator)
        
        setup()
    }
}

// MARK: - Setup description

private extension MainDescriptionCoordinator {
    func setup() {
        let frame1 = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        let frame2 = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        mainDescriptionViewController.addChild(bluetoothDataCoordinator.rootViewController)
        mainDescriptionViewController.addChild(descrionViewCoordinator.rootViewController)
        
        mainDescriptionViewController.scrollView.addSubview(bluetoothDataCoordinator.rootViewController.view)
        mainDescriptionViewController.scrollView.addSubview(descrionViewCoordinator.rootViewController.view)
        
        bluetoothDataCoordinator.rootViewController.view.frame = frame1
        descrionViewCoordinator.rootViewController.view.frame = frame2
        
        mainDescriptionViewController.navigationItem.title = "\(bluetoothId)"
    }
}
