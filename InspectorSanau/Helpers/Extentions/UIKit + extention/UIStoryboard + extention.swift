//
//  UIStoryboard + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

extension UIStoryboard {
    static func loadViewController<View: UIViewController>() -> View {
        let name = String(describing: View.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: name) as! View
        return viewController
    }
}

