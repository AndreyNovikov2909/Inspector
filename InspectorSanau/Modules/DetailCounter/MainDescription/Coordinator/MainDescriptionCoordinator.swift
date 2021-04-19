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
    private let descrionViewCoordinator = DescriptionCoordinator()
    private let item: BluetoothWapped
    
    // MARK: - Object livecycle
    
    init(navigationController: UINavigationController, item: BluetoothWapped) {
        self.navigationController = navigationController
        self.mainDescriptionViewController = UIStoryboard.loadViewController()
        self.item = item
        self.bluetoothDataCoordinator = BluetoothDataCoordinator(item: item)
        print(mainDescriptionViewController.view.frame)
    }
    
    override func start() {
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
    }
}
