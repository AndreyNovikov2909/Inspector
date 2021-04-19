//
//  UIImageView + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

extension UIImageView{
    func changeColor(color: UIColor?) {
        guard let image =  self.image else {return}
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
