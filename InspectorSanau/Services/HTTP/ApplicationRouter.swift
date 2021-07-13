//
//  AuthHTTPRouter.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/22/21.
//

import Alamofire
import Foundation

enum ApplicationRouter {

    // sign up
    case signUp(param: [String: Any])
    case signUpActivation(param: [String: Any])
    
    // login
    case login(param: [String: Any])       
    
    // code API
    
    /// for activation field if forActivation = true for activation user, if forActivation = false for reset passsword
    case resendSMS(param: [String: Any])
    case sendSMS(param: [String: Any])
    
    case getCodeForResetPassword(param: [String: Any]) // get sms
    case checkSMS(param: [String: Any]) // check SMS
    case confirmNewPassword(param: [String: Any]) // set new password
    
    // room API
    case saveRoom(params: [String: Any])
    case deleteRoom(params: [String: Any])
    case renameRoom(params: [String: Any])
    
    // account
    case resetPassword(params: [String: Any])
    case refrestToken(params: [String: Any])
    
    // device API
    case saveDevice(params: [String: Any])
    
    // system
    case getOperatorProfile(params: [String:  Any])
    case putNewPassword(params: [String: Any])
    
    // location
    case getRegion(params: [String: Any])
    case getCites(params: [String: Any])
    
    // bluetooth
    
//    case getAllBluetooth([String: Any])
//    case bluetoothSearchMetter([String: Any])
//    case bluetoothFilterByType([String: Any])
//    case bluetoothGetInfo([String: Any])
//    case bluetoothAddMetterData([String: Any])

 
    // bluettoth info
    case getBluetoothHumanData([String: Any])
    case sendBluetoothData([String: Any])
    
    // bluetooth
    case getAllMetters([String: Any])
    case getMattersFromName([String: Any])
    
    case extelData([String: Any])
    
}

// MARK: - HTTPRouter

extension ApplicationRouter: HTTPRouter {
    var baseURLString: String {
        return "http://192.248.186.53:8084/api/v1"
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/account/sign-up"
        case .signUpActivation:
            return "/account/activate"
        case .login:
            return "/account/sign-in"
        case .resendSMS:
            return "/account/resend/code"
        case .sendSMS:
            return "/account/send/code"
        case .getCodeForResetPassword:
            return "/account/send/reset/code"
        case .checkSMS:
            return "/account/restore/codeCheck"
        case .confirmNewPassword:
            return "/account/restore/password"
        
        // rooms
        case .saveRoom:
            return "/system/add/room"
        case .deleteRoom:
            return "/system/delete/room"
        case .renameRoom:
            return "/system/edit/room"
            
        // device
        case .saveDevice:
            return "/devices/add"
            
        // account
        case  .resetPassword:
            return "/account/send/email/reset/password"
        case .refrestToken:
            return "account/refresh/token/operator"
        // system
        case .putNewPassword:
            return "/operator-system/change/password"
        case .getOperatorProfile:
            return "/operator-system/profile"
            
        // location
        case .getRegion:
            return "/location/regions"
        case .getCites:
            return "/location/cities"
            
        // bluetooth
        case .getBluetoothHumanData:
            return "/bluetooth-meters/by/serial-number"
        case .sendBluetoothData:
            return "/bluetooth-meters/data/add"
            
        //
        case .getAllMetters:
            return "/bluetooth-meters/all"
        case .getMattersFromName:
            return "/bluetooth-meters/search"
            
            //
        case .extelData:
            return "/bluetooth-meters/data/excel"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp,
             .login,
             .checkSMS,
             .getCodeForResetPassword,
             .resetPassword,
             .refrestToken,
             .getBluetoothHumanData,
             .sendBluetoothData,
             .getCites, // ["region": ]
             .getMattersFromName:
            return .post
        case .signUpActivation, .resendSMS, .sendSMS, .confirmNewPassword, .putNewPassword:
            return .put
            
        // get
        case .getOperatorProfile,
             .getRegion,
             .getAllMetters:
            return .get
            
            
        // rooms
        case .saveRoom:
            return .post
        case .renameRoom:
            return .put
        case .deleteRoom:
            return .delete
        // device
        case .saveDevice, .extelData:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        print(DefaultsService.shared.getTokens().refreshToken ?? "  <---> Token is nil")
        return ["Authorization": DefaultsService.shared.getTokens().refreshToken ?? "",
                "Content-Type": "application/json;charset=UTF-8"]
    }
    
    var parameters: Parameters? {
        switch self {
        case .deleteRoom(let params):
            return params
        default: return nil
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURLString + path) else {
            throw HTTPError.urlIsNil
        }
        
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = method.rawValue
        
        if let headars = headers {
            headars.forEach { header in
                print(header.name, header.value)
                mutableURLRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        print(mutableURLRequest.url)
        
        switch self {
        case .getOperatorProfile,
             .getRegion:
            return try URLEncoding.default.encode(mutableURLRequest, with: [:])
        
        case .signUp(let param),
             .signUpActivation(let param),
             .login(let param),
             .resendSMS(let param),
             .sendSMS(let param),
             .getCodeForResetPassword(let param),
             .checkSMS(let param),
             .confirmNewPassword(let param),
             
             .resetPassword(let param),
             .putNewPassword(let param),
             .refrestToken(let param),
             .getCites(let param),
             .getBluetoothHumanData(let param),
             .sendBluetoothData(let param),
             .getMattersFromName(let param):
            
            if case .getMattersFromName = self {
                var params = param
                let newParam = ["query": params["query"] ?? ""]
                params["query"] = nil
                mutableURLRequest.url = try setQueryItems(from: params, urlString: url.absoluteString)
                return try JSONEncoding.default.encode(mutableURLRequest, with: newParam)
            }
            
            return try JSONEncoding.default.encode(mutableURLRequest, with: param)
            
        case .saveRoom(let param),
             .renameRoom(let param),
             .saveDevice(let param),
             .extelData(let param):
            
            let data = try getBody(fromParams: param)
            mutableURLRequest.httpBody = data
        return mutableURLRequest
            
        case .deleteRoom(let params),
             .getAllMetters(let params):
            mutableURLRequest.url = try setQueryItems(from: params, urlString: url.absoluteString)
        return mutableURLRequest
        }
    }
    
    
    // MARK: - Private methods
    
    private func getBody(fromParams params: [String: Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: params, options: [])
    }
    
    private func setQueryItems(from params: [String: Any], urlString: String?) throws -> URL {
        guard let urlString = urlString else {
            throw NSError(domain: "The urlString is nil, method: \(#function), line: \(#line)", code: 0, userInfo: [:])
        }

        var urlComponents = URLComponents(string: urlString)
        let items = params.map({ return URLQueryItem(name: $0.key, value: ($0.value as? String) ?? "") })
        urlComponents?.queryItems = items
        
        if let url = urlComponents?.url {
            return url
        } else {
            throw NSError(domain: "The url is nil, method: \(#function), line: \(#line)", code: -1, userInfo: [:])
        }
    }
}
