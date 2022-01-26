//
//  APIBaseProtocol.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/26.
//

import Foundation
import Alamofire

/// API Protocol
protocol APIBaseProtocol {
    
    /// レスポンスタイプ
    associatedtype ResponseType
    
    /// GET, POST等
    var method: HTTPMethod { get }
    /// 呼び出し元。今回は、"https://pokeapi.co/api/v2/"
    var baseURL: URL { get }
    /// 呼び出し元から先のパス
    var path: String { get }
    /// ヘッダー
    var headers: HTTPHeaders? { get }
    /// デコード
    var decode: (Data) throws -> ResponseType { get }
    
}

extension APIBaseProtocol {
    
    var baseURL: URL {
        return try! APIComponents.basePath.asURL()
    }
    
    var headers: HTTPHeaders? {
        return APIComponents.header
    }
    
    /*var decode: (Data) throws -> ResponseType {
        return { try! JSONDecoder }
    }*/
    
}
