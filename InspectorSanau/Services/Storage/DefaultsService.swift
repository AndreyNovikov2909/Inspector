//
//  DefaultsService.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/28/21.
//

import Foundation

protocol DefaultsServicePresebtable {
    
}

class DefaultsService: DefaultsServicePresebtable {
    static let shared = DefaultsService()
    private let standart = UserDefaults.standard
    private init() {}
    
    // MARK: - Nested type
    
    typealias Tokenable = (refreshToken: String?, accessToken: String?)
    
    // MARK: - Keys
    
    static let auth_key = "auth_key"
    static let rooms_key = "rooms_key"
    static let first_launch_key = "firstlaunch_key"
    static let access_token_key = "access_token"
    static let refresh_token_key = "refresh_token"
    
    // MARK: - Methods
    
    // auth
    
    func setAuth(value: Bool) {
        standart.setValue(value, forKey: DefaultsService.auth_key)
    }
    
    func isAuth() -> Bool {
        return (standart.value(forKey: DefaultsService.auth_key) as? Bool) ?? false
    }
    
    // rooms
    
    func setRooms(rooms: [String]) {
        standart.setValue(rooms, forKey: DefaultsService.rooms_key)
    }
    
    func getRooms() -> [String] {
        return (standart.value(forKey: DefaultsService.rooms_key) as? [String]) ?? []
    }
    
    // first launch
    
    func isFirstLaunch() -> Bool {
        return standart.value(forKey: DefaultsService.first_launch_key) as? Bool ?? true
    }
    
    func setFirstLaunch(value: Bool) {
        standart.setValue(value, forKey: DefaultsService.first_launch_key)
    }
    
    
    // tokens
    
    func saveTokens(tokenable: Tokenable) {
        standart.setValue(DefaultsService.access_token_key, forKey: tokenable.accessToken ?? "")
        standart.setValue(DefaultsService.refresh_token_key, forKey: tokenable.refreshToken ?? "")
    }
    
    func getTokens() -> Tokenable {
        let refreshToken = standart.value(forKey: DefaultsService.refresh_token_key) as? String
        let accessToken = standart.value(forKey: DefaultsService.access_token_key) as? String
        
        return (refreshToken: refreshToken, accessToken: accessToken)
    }
}

