//
//  DeviceObject.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import Foundation
import Realm
import RealmSwift

class DeviceObject: Object {
    @objc dynamic var uuID: String?
    @objc dynamic var name: String?
    @objc dynamic var originalName: String?
    @objc dynamic var roomName: String?
    @objc dynamic var type: String?
    
    let scanList = List<ScanObject>()
}
