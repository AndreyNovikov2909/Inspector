//
//  AuthResponse.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation

struct AuthResponse: Decodable {
    var message: String?
    var status: Int?
    var error: String?
    var path: String?
    var accessToken: String?
    var refreshToken: String?
}
