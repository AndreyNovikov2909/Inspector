//
//  HTTPManager.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import Alamofire
import RxSwift
import UIKit

class HTTPManager: HTTPService, DecodePresentable {

    
    var session: Session = Alamofire.Session.default
    
    func request<T>(request: URLRequestConvertible) -> Single<T> where T : Decodable {
        return Single.create { (single) -> Disposable in
            self.session.request(request).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let _ = response.response?.statusCode else {
                        single(.error(HTTPError.statusCodeIsNil))
                        return
                    }
                    guard let value = response.value else {
                        single(.error(HTTPError.responseValuesIsNil))
                        return
                    }
                    
                    print(value)
                    
                    let dict = value as? [String: Any]
                    let status = dict?["status"] as? Int
                    let message = dict?["message"] as? String
                    let error = dict?["error"] as? String
                    let path = dict?["path"] as? String
                    let accessToken = dict?["accessToken"] as? String
                    let refreshToken = dict?["refreshToken"] as? String
                    
                    let authResponse = AuthResponse(message: message,
                                                    status: status,
                                                    error: error,
                                                    path: path,
                                                    accessToken: accessToken,
                                                    refreshToken: refreshToken)
                    
                    single(.success(authResponse as! T))
                
                case .failure(let error):
                    guard let _ = response.response?.statusCode else {
                        single(.error(HTTPError.statusCodeIsNil))
                        return
                    }
                    
                    single(.error(error))
                }
            }

            return Disposables.create()
        }
    }
    
    
    // MARK: - Room request
    
    func decodableRequest<T: Decodable>(request: URLRequestConvertible) -> Single<T> {
        return Single<T>.create { (single) -> Disposable in
            
            self.session.request(request).responseJSON { (afResponse) in
                guard let data = afResponse.data else {
                    single(.error(HTTPError.dataIsNil))
                    return
                }
                
                switch afResponse.result {
                case .success(let value):
                    do {
                        let decodedValue: T = try self.decode(data: data)
                        single(.success(decodedValue))
                        return
                    } catch {
                        single(.error(error))
                    }


                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

