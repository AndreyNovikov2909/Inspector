//
//  Counter.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/17/21.
//

import RxSwift
import RxRelay
import Foundation

enum CounterEvent<T> {
    case element(element: T)
    case end
}

class Counter {
    static let shared = Counter()
    
    var onComplite = BehaviorRelay<CounterEvent<Int>>.init(value: .element(element: 20))
    var count = 20
    private var timer: Timer!
    
    private init() {}
    
    func activate() {
        count = 20
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(timer: Timer) {
        if count == 0 {
            timer.invalidate()
            onComplite.accept(.end)
        } else {
            count -= 1
            onComplite.accept(.element(element: count))
        }
        
    }
}
