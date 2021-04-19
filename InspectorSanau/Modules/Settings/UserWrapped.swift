//
//  UserWrapped.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation


protocol UserPresentable {
    var firstName: String { get set }
    var middleName: String { get set }
    var lastName: String { get set }
    var phoneNumber: String { get set }
    var email: String { get set }
}

struct UserWrapped: Decodable, UserPresentable {
    var firstName: String
    var middleName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var id: Double
}
