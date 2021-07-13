//
//  BluetoothDataCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit
import RxSwift
import RxCocoa

class BluetoothDataCoordinator: BaseCoodinator {
    
    override var rootViewController: UIViewController {
        return bluetoothDataViewController
    }
    
    var stopObserving = PublishRelay<Void>.init()
    
    private let dispose = DisposeBag()
    private let bluetoothDataViewController: BluetoothDataViewController
    private let item: BluetoothWapped
    private let realmSercice =  try! RealmService()
    private let id: String
    
    init(item: BluetoothWapped, id: String) {
        bluetoothDataViewController = UIStoryboard.loadViewController()
        self.item = item
        self.id = id
    }
    
    override func start() {
        bluetoothDataViewController.builder = { input in
            
            let viewModel = BluetoothDataViewModel(input: input,
                                                   httpManager: HTTPManager(),
                                                   realmSercice: self.realmSercice,
                                                   deviceObject: self.getDeviceObject(),
                                                   id: self.id)
            viewModel
                .routing
                .showErrorAlert
                .map({ self.showErrorAlert() })
                .drive()
                .disposed(by: self.dispose)
            
            return viewModel
        }
    }
}

// MARK: - Process

private extension BluetoothDataCoordinator {
    func getDeviceObject() -> DeviceObject {
        if let deviceObject: DeviceObject = realmSercice.getObjects().first(where: { $0.originalName == item.name }) {
            return deviceObject
        } else {
            let newObject = DeviceObject()
            newObject.originalName = item.name
            newObject.uuID = UUID().uuidString
            
            try? realmSercice.saveObject(value: newObject)
            return newObject
        }
    }
}

// MARK: - Routing

private extension BluetoothDataCoordinator {
    func showErrorAlert() {
        let errorView = bluetoothDataViewController.errorAlert(title: "Счетчик не найден")
        // bluetoothDataViewController.view.bringSubviewToFront(bluetoothDataViewController.view)
    }
}
