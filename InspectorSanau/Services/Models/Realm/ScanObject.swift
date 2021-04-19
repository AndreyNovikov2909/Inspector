//
//  ScanObject.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import Foundation

import Foundation
import RealmSwift

class ScanObject: Object {
    @objc dynamic var metterValue: Double = 0
    @objc dynamic var date: String?
}
