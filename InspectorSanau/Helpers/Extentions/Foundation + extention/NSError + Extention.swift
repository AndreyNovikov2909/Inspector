//
//  NSError + Extention.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/24/21.
//

import Foundation

extension NSError {
    static func generateError(description: String?, code: Int?) -> NSError {
        return NSError(domain: description ?? "", code: code ?? -1, userInfo: [:])
    }
}
