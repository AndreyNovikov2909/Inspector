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
    private let dispose = DisposeBag()
    
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
                    
                    if let s = status, s == 401 {
                        let result: Single<T> = self.request(request: request)
                        result.asObservable().subscribe { (event) in
                            switch event {
                            case .next(let decoded):
                                let decodedDict = decoded as? [String: Any]
                                let status1 = decodedDict?["status"] as? Int
                                let message1 = decodedDict?["message"] as? String
                                let error1 = decodedDict?["error"] as? String
                                let path1 = decodedDict?["path"] as? String
                                let accessToken1 = decodedDict?["accessToken"] as? String
                                let refreshToken1 = decodedDict?["refreshToken"] as? String
                                
                                let authResponse = AuthResponse(message: message1,
                                                                status: status1,
                                                                error: error1,
                                                                path: path1,
                                                                accessToken: accessToken1,
                                                                refreshToken: refreshToken1)
                                
                                single(.success(authResponse as! T))
                                
                            case .error(let error):
                                single(.error(error))
                            case .completed:
                                break
                            }
                        }.disposed(by: self.dispose)
                        
                    } else {
                        let authResponse = AuthResponse(message: message,
                                                        status: status,
                                                        error: error,
                                                        path: path,
                                                        accessToken: accessToken,
                                                        refreshToken: refreshToken)
                        
                        single(.success(authResponse as! T))
                    }
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
                guard let data = afResponse.data,
                      let stausCode = afResponse.response?.statusCode else {
                    single(.error(HTTPError.dataIsNil))
                    return
                }
                
                switch afResponse.result {
                case .success(let value):
                    do {
                        // expared token
                        if stausCode == 401 {
                            let tokens: Single<TokenPresentable> = self.resetToken()
                            tokens.asObservable().subscribe { (event) in
                                switch event {
                                case .next(_):
                                    let result: Single<T> = self.decodableRequest(request: request)
                                    result.asObservable().subscribe { (finalEvent) in
                                        switch finalEvent {
                                        case .next(let decoded):
                                            single(.success(decoded))
                                        case .error(let error):
                                            single(.error(error))
                                        case .completed:
                                            break
                                        }
                                    }.disposed(by: self.dispose)
                                case .error(let error):
                                    single(.error(error))
                                case .completed:
                                    break
                                }
                                
                            }.disposed(by: self.dispose)
                            
                        } else {
                            let decodedValue: T = try self.decode(data: data)
                            single(.success(decodedValue))
                        }
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
    
    func downLoadExel(request: URLRequestConvertible) -> Single<Data> {
        return Single<Data>.create { (single) -> Disposable in
            
            self.session.request(request).responseJSON { (afResponse) in
                guard let data = afResponse.data, let stausCode = afResponse.response?.statusCode else {
                    single(.error(HTTPError.dataIsNil))
                    return
                }
                
                single(.success(data))
                
                switch afResponse.result {
                case .success(let value):
                    // expared token
                    if stausCode == 401 {
                        let tokens: Single<TokenPresentable> = self.resetToken()
                        tokens.asObservable().subscribe { (event) in
                            switch event {
                            case .next(_):
                                let result: Single<Data> =  self.downLoadExel(request: request)
                                result.asObservable().subscribe { (finalEvent) in
                                    switch finalEvent {
                                    case .next(let decoded):
                                        single(.success(decoded))
                                    case .error(let error):
                                        single(.error(error))
                                    case .completed:
                                        break
                                    }
                                }.disposed(by: self.dispose)
                            case .error(let error):
                                single(.error(error))
                            case .completed:
                                break
                            }
                            
                        }.disposed(by: self.dispose)
                    } else {
                        single(.success(data))
                    }
                
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    func resetToken<T: Decodable>() -> Single<T> {
        return Single<T>.create { (tokenSignle) -> Disposable in
            let params = ["refreshToken": DefaultsService.shared.getTokens().refreshToken ?? ""]
            do {
                try self.session.request(ApplicationRouter.refrestToken(params: params).asURLRequest()).responseJSON(completionHandler: { (afResponse) in
                    guard let value = afResponse.value else {
                        tokenSignle(.error(HTTPError.dataIsNil))
                        return
                    }
                    
                    if let dict = value as? [String: Any],
                       let accessToken = dict["accessToken"] as? String,
                       let refreshToken = dict["refreshToken"] as? String {
                       
                        let auth = TokenPresentable(accessToken: accessToken,
                                                 refreshToken: refreshToken)
                        
                        DefaultsService.shared.saveTokens(tokenable: (refreshToken, accessToken))
                        tokenSignle(.success(auth as! PrimitiveSequence<SingleTrait, T>.Element))
                    } else {
                        tokenSignle(.error(HTTPError.statusCodeIsNil))
                    }
                })
            } catch {
                tokenSignle(.error(error))
            }
            return Disposables.create()
        }
    }
}

struct TokenPresentable: Decodable {
    var accessToken: String
    var refreshToken: String
}
