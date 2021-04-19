//
//  HTTPRouter.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation
import Alamofire

protocol HTTPRouter {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func asURLRequest() throws -> URLRequest
}

