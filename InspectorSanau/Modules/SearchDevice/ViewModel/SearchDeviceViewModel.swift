//
//  SearchDeviceViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/16/21.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa


struct BluetoothWapped: BluetoothCellPresentable {
    var name: String
}


protocol SearchDeviceViewModelPresentable {
    typealias Input = (selectedCounter: Driver<BluetoothWapped>, ())
    typealias Output = (bluetoothWapped: Driver<[BluetoothWapped]>, ())
    typealias RoutingAction = (selectedCounter: PublishRelay<BluetoothWapped>, ())
    typealias Routing = (showCounterDetail: Driver<BluetoothWapped>, ())
    typealias Builder = (Input) -> SearchDeviceViewModelPresentable

    var input: Input { get set }
    var output: Output { get set }
}


final class SearchDeviceViewModel: SearchDeviceViewModelPresentable {
    
    var input: Input
    var output: Output
    lazy var routing: Routing = (showCounterDetail: routingAction.selectedCounter.asDriver(onErrorDriveWith: .empty()), ())
    private let routingAction: RoutingAction = (selectedCounter: PublishRelay<BluetoothWapped>(), ())
    private let bluetoothWrapped = PublishRelay<[BluetoothWapped]>()
    
    private let bluetoothManager: BluetoothManager
    private let dispose = DisposeBag()
    
    init(input: Input, bluetoothManager: BluetoothManager) {
        self.input = input
        self.output = SearchDeviceViewModel.output(input: input, bluetoothWrapped: bluetoothWrapped)
        self.bluetoothManager = bluetoothManager
        bluetoothManager.start()
        bluetoothManager.myDelegate = self
        
        selectedRocess()
    }
}

// MARK: - Process

private extension SearchDeviceViewModel {
    func selectedRocess() {
        input
            .selectedCounter
            .map({ self.routingAction.selectedCounter.accept($0) })
            .drive()
            .disposed(by: dispose)
    }
}

// MARK: - Output

private extension SearchDeviceViewModel {
    static func output(input: SearchDeviceViewModelPresentable.Input,
                       bluetoothWrapped: PublishRelay<[BluetoothWapped]>) -> SearchDeviceViewModelPresentable.Output {
        (bluetoothWapped: bluetoothWrapped.asDriver(onErrorDriveWith: .never()),
         ())
    }
}


extension SearchDeviceViewModel: BluetoothManagerDelegate {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveCharacteristics characteristics: [CBCharacteristic]) {
        
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didUpdatePeripheralsName names: [String]) {
        let wrapped = names.map { BluetoothWapped(name: $0) }
        bluetoothWrapped.accept(wrapped)
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveByteArray byteArray: [UInt8]) {
        
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveConnectedState state: Bool) {
        
    }
}
