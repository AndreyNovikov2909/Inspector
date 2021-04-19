//
//  HTTPError.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/24/21.
//

import Foundation

enum HTTPError: Error {
    case statusCodeIsNil
    case responseValuesIsNil
    case urlIsNil
    case dataIsNil
    case requestIsNil
    case responseValueIsNil
}
