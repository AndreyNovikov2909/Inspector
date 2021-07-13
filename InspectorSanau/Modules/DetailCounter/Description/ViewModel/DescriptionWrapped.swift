//
//  DescriptionWrapped.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import Foundation

struct DescriptionWrapped: DescriptionPresentable {
    var leftTitle: String
    var rightTitle: String
}


struct UserWrrapped: Decodable {
    var serialNumber: String?
    var personalAccountNumber: String?
    var fullName: String?
    var location: String?
    var createdAt: String?
    var lastFixDate: String?
    var type: String?
}
