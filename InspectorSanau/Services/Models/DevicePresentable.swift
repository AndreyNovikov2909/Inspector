//
//  DevicePresentable.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/26/21.
//

import Foundation

enum DevicesPresentable {
    case addDevice(presentableItems: [String])
    case addToRoms(presentableItems: [String])
    
    var title: String {
        switch self {
        case .addDevice:
            return "Добавить устройство"
        case .addToRoms:
            return "Управление комнатами"
        }
    }
    
    var count: Int {
        switch self {
        case .addDevice(let items):
            return items.count
        case .addToRoms(let items):
            return items.count
        }
    }
    
    var presentableItems: [String] {
        switch self {
        case .addDevice(let items):
            return items
        case .addToRoms(let items):
            return items
        }
    }
}

