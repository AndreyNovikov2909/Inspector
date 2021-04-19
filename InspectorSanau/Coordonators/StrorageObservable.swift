//
//  StrorageObservable.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation

@propertyWrapper struct DefaultsObservable<Value> {
 
    // MARK: - Instance methods
    
    var wrappedValue: Value? {
        set { defaultsService.setValue(newValue, forKey: defaultsKey) }
        get {
            let value = defaultsService.value(forKey: defaultsKey) as? Value
            return value
        }
    }
    
    
    var defaultsKey: String
    
    // MARK: - Private properties
    
    private let defaultsService = UserDefaults.standard
    
    // MARK: - Init
    
    init(key: String) {
        defaultsKey = key
    }
}
