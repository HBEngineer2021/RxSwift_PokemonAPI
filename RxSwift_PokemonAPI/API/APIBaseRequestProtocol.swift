//
//  APIBaseRequestProtocol.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/26.
//

import Foundation
import Alamofire

protocol APIBaseRequestProtocol: APIBaseProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension APIBaseRequestProtocol {
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers!
        urlRequest.timeoutInterval = TimeInterval(15)
        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}
