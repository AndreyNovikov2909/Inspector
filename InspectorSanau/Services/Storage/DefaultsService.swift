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
    static let search_city_key = "search_city"
    static let search_district_key = "search_district"
    static let phase_key = "pahse_key"
    static let search_state = "search_key"
    static let discrict_key = "disctrict_key"
    static let city_key = "city_key"

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
    
    // search
    
    func setSearchCity(_ city: String) {
        standart.setValue(city, forKey: DefaultsService.search_city_key)
    }
    
    func setSearchDistric(_ distric: String) {
        standart.setValue(distric, forKey: DefaultsService.search_district_key)
    }
    
    func getCity() -> String? {
        standart.value(forKey: DefaultsService.search_city_key) as? String
    }
    
    func getDiscric() -> String? {
        standart.value(forKey: DefaultsService.search_district_key) as? String
    }
    
    func removeSearch() {
        standart.setValue(nil, forKey: DefaultsService.search_city_key)
        standart.setValue(nil, forKey: DefaultsService.search_district_key)
    }
    
    func deleteUser() {
        standart.setValue(nil, forKey: "email")
        standart.setValue(nil, forKey: "fullName")
        standart.setValue(nil, forKey: "phoneNumber")
        standart.setValue(nil, forKey: "roleName")
    }
    
    func setUser(_ user: UserWrapped) {
        standart.setValue(user.email ?? "", forKey: "email")
        standart.setValue(user.fullName ?? "", forKey: "fullName")
        standart.setValue(user.phoneNumber ?? "", forKey: "phoneNumber")
        standart.setValue(user.roleName, forKey: "roleName")
    }
    
    func getUser() -> UserWrapped {
        let email = standart.value(forKey: "email") as? String
        let fullName = standart.value(forKey: "fullName") as? String
        let phoneNumber = standart.value(forKey: "phoneNumber") as? String
        let roleName = standart.value(forKey: "roleName") as? String
        return UserWrapped(fullName: fullName, email: email, phoneNumber: phoneNumber, roleName: roleName)
    }
    
    // phase
    
    func getCurrenctPhase() -> TypeMetterViewModel.TypeMetter {
        guard
            let key = standart.value(forKeyPath: DefaultsService.phase_key) as? String,
            let value = TypeMetterViewModel.TypeMetter(rawValue: key)
        else { return .all }
        
        return value
    }
    
    func setPhase(_ value: TypeMetterViewModel.TypeMetter) {
        standart.setValue(value.rawValue, forKey: DefaultsService.phase_key)
    }
    
    func setCurrentSate(_ state: SearchState) {
        switch state {
        case .done(let city, let district):
            standart.setValue("done", forKey: DefaultsService.search_state)
            setSearchCity(city)
            setSearchDistric(district)
        case .city:
            standart.setValue("city", forKey: DefaultsService.search_state)
        default: break
        }
    }
    
    
    func getCurrentState() -> SearchState {
        if let value = standart.value(forKey: DefaultsService.search_state) as? String,
           let city = getCity(),
           let discrict = getDiscric() {
            
            if value == "done" {
                return .done(city: city, district: discrict)
            } else {
                return .city
            }
        }
        
        return .city
    }
}

