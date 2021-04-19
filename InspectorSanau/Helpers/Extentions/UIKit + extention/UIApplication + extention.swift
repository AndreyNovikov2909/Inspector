//
//  UIKit + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

extension UIApplication {
    var window: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}
