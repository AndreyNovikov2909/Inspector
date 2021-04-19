//
//  User.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation
import RealmSwift


class User: Object {
    @objc var firstName: String = ""
    @objc var middleName: String = ""
    @objc var lastName: String = ""
    @objc var phoneNumber: String = ""
    @objc var email: String = ""
    @objc var id: Double = 0
}
