//
//  UIView + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

extension UIView {
    func addBorder(color: UIColor? = K.Colors.textColor2) {
        layer.borderWidth = 1.5
        layer.borderColor = color?.cgColor
    }
    
    func removeBorder(color: UIColor? = .white) {
        layer.borderWidth = 1.5
        layer.borderColor = color?.cgColor
    }
}

