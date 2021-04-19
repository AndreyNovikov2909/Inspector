//
//  Coordinator.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

protocol Coordinator: class {
    var rootViewController: UIViewController { get }
    var childs: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(_ coodinator: Coordinator) {
        childs.append(coodinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        childs = childs.filter { $0 !== coordinator }
    }
}
