//
//  CGFloat + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation
import CoreGraphics

extension CGFloat {
    var clean: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0

        return formatter.string(from: self as NSNumber) ?? ""
    }
}
