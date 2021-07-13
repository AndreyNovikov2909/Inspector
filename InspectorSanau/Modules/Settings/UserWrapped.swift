//
//  UserWrapped.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation


protocol UserPresentable {
    var fullName: String? { get set }
    var email: String? { get set }
    var phoneNumber: String? { get set }
    var roleName: String? { get set }
}

struct UserWrapped: Decodable, UserPresentable {
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var roleName: String?
}
