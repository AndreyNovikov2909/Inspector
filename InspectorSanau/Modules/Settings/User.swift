//
//  User.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation
import RealmSwift


class User: Object {
    @objc var fullName: String?
    @objc var email: String?
    @objc var phoneNumber: String?
    @objc var roleName: String?
    @objc var date = Date()
}
