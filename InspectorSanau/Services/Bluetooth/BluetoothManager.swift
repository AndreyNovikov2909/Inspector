//
//  BluetoothManager.swift
//  Sanau
//
//  Created by Andrey Novikov on 3/9/21.
//

import Foundation
import CoreBluetooth


@objc protocol BluetoothManagerDelegate: class {
    @objc func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveCharacteristics characteristics: [CBCharacteristic])
    @objc func bluetoothManager(_ bluetoothManager: BluetoothManager, didUpdatePeripheralsName names: [String])
    @objc func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveByteArray byteArray: [UInt8])
    @objc func bluetoothManager(_ bluetoothManager: BluetoothManager, didReciveConnectedState state: Bool)
}

class BluetoothManager: NSObject {
    weak var myDelegate: BluetoothManagerDelegate?
    
    private let certificate1 = "FEFEFEFE68111111111111681104333333331716"
    private let certificate2 = "FEFEFEFE6801000000000068110433333333B216"

    
    var peripherals: Set<String> = []
    var needToConnect: Bool
    var byName: String?
    
    // MARK: - Private propertiees
    
    private var byteArray: [UInt8] = []
    var centralManger: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var charactiristics = [CBCharacteristic]()
    private var certificate: String?
    private var isConnected = false {
        didSet {
            myDelegate?.bluetoothManager(self, didReciveConnectedState: isConnected)
        }
    }
    private var peripheralName: String? {
        return peripheral.name
    }
        
    
    // MARK: - Object livecycle
    
    init(needToConnect: Bool = false, byName: String? = nil) {
        
        self.needToConnect = needToConnect
        self.byName = byName

        super.init()
    }
    
    // MARK: - Instanse methods
    
    func start() {
        centralManger = CBCentralManager(delegate: self, queue: nil)
        centralManger.scanForPeripherals(withServices: nil, options: nil)
        checkConnectionState()
    }
    
    func stop() {
        centralManger.stopScan()
    }
    
    
    func getValue() {
        if isConnected {
            let byteArray = convertToByteArray(value: certificate ?? "")
            let data = Data(byteArray)
            
            for characteristic in charactiristics {
                peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        } else {
            start()
        }
    }
    
    private func checkConnectionState() {
        if let _ = byName, needToConnect {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
                guard let self = self else { return }
                if self.isConnected == false {
                    self.myDelegate?.bluetoothManager(self, didReciveConnectedState: false)
                } else {
                    self.getValue()
                }
                
                timer.invalidate()
            }
        }
    }
    
    // MARK: - Methods
    
    private func convertToByteArray(value: String) -> [UInt8] {
        var hexString = value
        hexString = hexString.uppercased()
        let lenght = hexString.count / 2
        let hexChars: [Character] = Array(hexString)
        var b: [UInt8] = []
        
        for i in 0..<lenght {
            let pos = i * 2
            
            let value = UInt8(charToByte(c: hexChars[pos]) << 4 | charToByte(c: hexChars[pos + 1]))
            b.append(value)
        }
        
        return b
    }
    
    
    private func charToByte(c: Character) -> Int {
        let str = "0123456789ABCDEF"
        let i = str.firstIndex(of: c)!
        let index: Int = str.distance(from: str.startIndex, to: i)
        return index
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case .unknown:
          print("central.state is .unknown")
        case .resetting:
          print("central.state is .resetting")
        case .unsupported:
          print("central.state is .unsupported")
        case .unauthorized:
          print("central.state is .unauthorized")
        case .poweredOff:
          print("central.state is .poweredOff")
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
          print("central.state is .poweredOn")
        @unknown default:
            print("Unknown default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
   
        
        if let name = peripheral.name {
            print(name)

            
            if name.hasPrefix("CJ") {
                self.certificate = "FEFEFEFE68111111111111681104333333331716"
                appendPeripheral(peripheral)
            } else if name.hasPrefix("LM") {
                self.certificate = "FEFEFEFE6801000000000068110433333333B216"
                appendPeripheral(peripheral)
            }
            
            if let byName = byName, needToConnect, byName == name {
                centralManger.connect(peripheral, options: nil)
                centralManger.stopScan()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
    }
    
    private func appendPeripheral(_ peripheral: CBPeripheral) {
        if let name = peripheral.name {
            peripherals.insert(name)
            var names = [String]()
            _ = peripherals.map { names.append($0) }
            myDelegate?.bluetoothManager(self, didUpdatePeripheralsName: names)
        }
    }
}

// MARK: - CBPeripheralDelegate

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            // MARK: - Handling services
            return
        }
        
        for service in services {
            print("Service did connect, service - \(services)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            // MARK: - Handling charlist
            return
        }
        
        self.charactiristics = characteristics
        isConnected = true
        
        for characteristic in characteristics {
            print("Characteristics did connect, characteristic - \(characteristic)")
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
            }
            
            if characteristic.properties.contains(.notify) {
              print("\(characteristic.uuid): properties contains .notify")
            }
            
            if characteristic.properties.contains(.writeWithoutResponse) {
                print("\(characteristic.uuid): properties containts .writeWithoutResponse")
            }
            
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties containts .write")
            }
            
            myDelegate?.bluetoothManager(self, didReciveCharacteristics: charactiristics)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let array = [UInt8](data)
            print("ARRAY: \(array) ---- \(array.count)")
            
            byteArray.append(contentsOf: array)
            
            if let certificate = certificate, certificate == certificate1 && byteArray.count == 22 {
                myDelegate?.bluetoothManager(self, didReciveByteArray: byteArray)
                byteArray.removeAll()
            } else if let certificate = certificate, certificate == certificate2 && byteArray.count == 20 {
                myDelegate?.bluetoothManager(self, didReciveByteArray: byteArray)
                byteArray.removeAll()
            } else  if byteArray.count > 22 {
                byteArray.removeAll()
            }
        }
    }
}

