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
    
    // device API
    case saveDevice(params: [String: Any])
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .login, .checkSMS, .getCodeForResetPassword:
            return .post
        case .signUpActivation, .resendSMS, .sendSMS, .confirmNewPassword:
            return .put
        // rooms
        case .saveRoom:
            return .post
        case .renameRoom:
            return .put
        case .deleteRoom:
            return .delete
        // device
        case .saveDevice:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .saveRoom, .deleteRoom, .renameRoom:
            return ["Authorization": "\(DefaultsService.shared.getTokens().accessToken ?? "")",
                    "Content-Type": "application/json;charset=UTF-8"]
        default:
            return nil
        }
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

        
        switch self {
        case .signUp(let param),
             .signUpActivation(let param),
             .login(let param),
             .resendSMS(let param),
             .sendSMS(let param),
             .getCodeForResetPassword(let param),
             .checkSMS(let param),
             .confirmNewPassword(let param):
            return try JSONEncoding.default.encode(mutableURLRequest, with: param)
            
        case .saveRoom(let param),
             .renameRoom(let param),
             .saveDevice(let param):
            
            let data = try getBody(fromParams: param)
            mutableURLRequest.httpBody = data
        return mutableURLRequest
            
        case .deleteRoom(let params):
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
