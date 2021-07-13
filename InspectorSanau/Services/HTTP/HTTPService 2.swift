//
//  HTTPService.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/23/21.
//

import Foundation
import Alamofire
import RxSwift

protocol DecodePresentable {
    func decode<T: Decodable>(data: Data?) throws -> T
}

protocol HTTPService {
    var session: Session { get set }
    func request<T: Decodable>(request: URLRequestConvertible) -> Single<T>
    func decodableRequest<T: Decodable>(request: URLRequestConvertible) -> Single<T>
}


extension DecodePresentable {
    func decode<T: Decodable>(data: Data?) throws -> T {
        guard let data = data else {
            throw HTTPError.dataIsNil
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}
