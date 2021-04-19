//
//  RealmService.swift
//  Sanau
//
//  Created by Andrey Novikov on 3/18/21.
//

import Foundation
import RealmSwift

protocol Realmable {
    init() throws
    func saveObject<Value: Object>(value: Value) throws
    func removeObject<Value: Object>(value: Value) throws
    func appendValue<Value: Object>(list: List<Value>, value: Value) throws
    func removeAlll() throws
    func getObjects<Value: Object>() -> [Value]
}

class RealmService: Realmable {
    // MARK: - Private propeties
    
    let realm: Realm
    
    // MARK: - Object live cycle
    
    required init() throws {
        do {

            realm = try Realm()
        } catch let realmErr {
            throw realmErr
        }
    }
    
    // MARK: - Instance methods
    
    func saveObject<Value: Object>(value: Value) throws {
        try realm.write {
            realm.add(value)
        }
    }
    
    func getObjects<Value: Object>() -> [Value] {
        var values: [Value] = []
        for value in realm.objects(Value.self) {
            values.append(value)
        }

        return values
    }
    
    func appendValue<Value: Object>(list: List<Value>, value: Value) throws {
        try realm.write {
            list.append(value)
        }
    }
    
    func removeObject<Value: Object>(value: Value) throws  {
        try realm.write {
            realm.delete(value)
        }
    }
    
    func removeAlll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
