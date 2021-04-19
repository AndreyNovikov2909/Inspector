//
//  BaseCoordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class BaseCoodinator: NSObject, Coordinator {
    var rootViewController: UIViewController {
        fatalError("This property should override child classes, line: \(#line)")
    }
    
    var childs: [Coordinator] = []
    
    func start() {
        fatalError("This method should override child classes, method: \(#function), line: \(#line)")
    }
}
