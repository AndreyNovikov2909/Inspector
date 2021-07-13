//
//  BluetoothDataViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import Foundation
import RxCocoa
import RxSwift
import CoreBluetooth

protocol ElectromicMetter2Presentable {
    var date: String { get set }
    var value: CGFloat { get set }
    var needToShow: Bool { get set }
}

struct BluetoothPresentable: ElectromicMetter2Presentable, GraphPresentable {
    var value: CGFloat
    var date: String
    var needToShow: Bool
}

protocol BluetoothDataViewModelPresentable {
    typealias Input = (loadData: Driver<Void>,
                       saveTap: Driver<Void>,
                       viewDidDisappear: Driver<Void>,
                       viewWillAppear: Driver<Void>)
    typealias Output = (dataPresentable: Driver<[BluetoothPresentable]>, ())
    typealias Builder = (Input) -> BluetoothDataViewModelPresentable
    typealias RouterAction = (bluetoothIsDisconnected: PublishRelay<Void>, ())
    typealias Router = (showErrorAlert: Driver<Void>, ())
    
    var input: Input { get set }
    var output: Output { get set }
}


final class BluetoothDataViewModel: BluetoothDataViewModelPresentable {
    
    var input: Input
    var output: Output
    lazy var routing: Router = (showErrorAlert: routerAction.bluetoothIsDisconnected.asDriver(onErrorDriveWith: .empty()), ())
    
    // MARK: - Managers
    
    private var bluetoothManager: BluetoothManager!
    private let realmService: RealmService
    private let httpManager: HTTPManager
    
    
    // MARK: - Private  proprties
    
    private let routerAction: RouterAction = (bluetoothIsDisconnected: PublishRelay<Void>.init() ,())
    private let deviceObject: DeviceObject
    private let bluetoothPresentable = BehaviorRelay<[BluetoothPresentable]>.init(value: [])
    private let showAlert = BehaviorRelay<Bool>.init(value: false)
    private let dispose = DisposeBag()
    private let id: String
    
    // MARK: - Init

    init(input: Input, httpManager: HTTPManager, realmSercice: RealmService, deviceObject: DeviceObject, id: String) {
        self.input = input
        self.output = BluetoothDataViewModel.output(input: input, dataPresentable: bluetoothPresentable)
        self.deviceObject = deviceObject
        self.httpManager = httpManager
        self.realmService = realmSercice
        self.id = id
        
        bluetoothManager = BluetoothManager(needToConnect: true, byName: deviceObject.originalName)
        bluetoothManager.myDelegate = self
        bluetoothManager.start()
        
        // process
        loadProcess()
        stopProcess()
        startProcess()
        saveTapProcess()
    }
}


// MARK: - Process

private extension BluetoothDataViewModel {
    func loadProcess() {
        input.loadData.asObservable().subscribe { _ in
            self.laod(needLoadFirst: false)
        }.disposed(by: dispose)
    }
    
    func laod(needLoadFirst: Bool) {
        guard let value: DeviceObject = realmService.getObjects().first(where: { $0.originalName == deviceObject.originalName }) else { return }
        var presentables: [BluetoothPresentable] = []
        
        for scanObject in value.scanList {
            let needToShow = presentables.count != 0 && needLoadFirst
            let presentable = BluetoothPresentable(value: CGFloat(scanObject.metterValue), date: scanObject.date ?? "", needToShow: needToShow)
            presentables.append(presentable)
        }
        
        bluetoothPresentable.accept(presentables.reversed())
    }
    
    
    func saveProcess(metterValue: Double) {
        let date = Date.getStringForServer()
        let params = ["serialNumber": id,
                      "indication": "\(metterValue)",
                      "lastFixDate": date,
                      "role": "ROLE_OPERATOR"]
        
        
        
//        guard let value: DeviceObject = self.realmService.getObjects().first(where: { $0.originalName == self.deviceObject.originalName }) else { return }
//        let scanObject = ScanObject()
//        scanObject.metterValue = metterValue
//        scanObject.date = Date().getCurentDate()
//        try? self.realmService.appendValue(list: value.scanList, value: scanObject)
//        self.laod(needLoadFirst: true)
        
        do {
            let value: Single<AuthResponse> = try httpManager.request(request: ApplicationRouter.sendBluetoothData(params).asURLRequest())
            value.subscribeOn(MainScheduler.instance).asObservable().subscribe { (event) in
                switch event {
                case .next(let result):
                    if result.status == 200 {
                        // MARK: - SEND
                        
//
                        guard let value: DeviceObject = self.realmService.getObjects().first(where: { $0.originalName == self.deviceObject.originalName }) else { return }
                        let scanObject = ScanObject()
                        scanObject.metterValue = metterValue
                        scanObject.date = Date().getCurentDate()
                        try? self.realmService.appendValue(list: value.scanList, value: scanObject)
                        self.laod(needLoadFirst: true)
                        
                        
                        
                    } else {
                
                    }
                case .error(let error):
                    print(error)
                case .completed:
                    break
                }
            }.disposed(by: dispose)
        } catch {
//            self.routerAction.
        }
    }
    
    func stopProcess() {
        input.viewDidDisappear.asObservable().subscribe { _ in
            if self.bluetoothManager != nil {
                self.bluetoothManager.stop()
                self.bluetoothManager = nil
            }
        }.disposed(by: dispose)
    }
    
    func startProcess() {
        input.viewWillAppear.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            if self.bluetoothManager == nil {
                self.bluetoothManager = BluetoothManager(needToConnect: true, byName: self.deviceObject.originalName ?? "")
                self.bluetoothManager.myDelegate = self
                self.bluetoothManager.start()
            }
        }.disposed(by: dispose)
    }
    
    func saveTapProcess() {
        input.saveTap.asObservable().subscribe { _ in
            self.bluetoothManager.getValue()
        }.disposed(by: dispose)
    }
}

// MARK: - Output

private extension BluetoothDataViewModel {
    static func output(input: BluetoothDataViewModelPresentable.Input,
                       dataPresentable: BehaviorRelay<[BluetoothPresentable]>) -> BluetoothDataViewModelPresentable.Output {
        let dataPresentable = dataPresentable.asDriver()
        
        return (dataPresentable: dataPresentable, ())
    }
}


// MARK: - BluetoothManagerDelegate

extension BluetoothDataViewModel: BluetoothManagerDelegate {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveCharacteristics characteristics: [CBCharacteristic]) {
        
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didUpdatePeripheralsName names: [String]) {
        
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveByteArray byteArray: [UInt8]) {
        let value = String.convert(byteArray: byteArray)
        let doubleValue = value.isEmpty ? 0 : (Double(value) ?? 0)
        saveProcess(metterValue: doubleValue)
    }
    
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveConnectedState state: Bool) {
        if state == false {
            laod(needLoadFirst: false)
            routerAction.bluetoothIsDisconnected.accept(Void())
        }
    }
}


extension Date {
    static func getStringForServer() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    func getStringForServer() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
}
