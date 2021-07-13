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


struct Metterresponse: Decodable {
    var page: Int
    var size: Int
    var hasNext: Bool
    var totalPage: Int
    var totalElementsOnPage: Int
    var elementsSize: Int
    var data: [MetterResponseData]
}

struct MetterResponseData: Decodable {
    var serialNumber: String
    var fullName: String
}
