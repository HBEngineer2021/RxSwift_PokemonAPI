//
//  APIResult.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/27.
//

import Foundation
import Alamofire

enum APIResult {
    case success(Decodable)
    case failure(Error)
}

extension JSONDecoder {

    convenience init(type: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = type
    }

    static let decoder: JSONDecoder = JSONDecoder(type: .useDefaultKeys)
}
