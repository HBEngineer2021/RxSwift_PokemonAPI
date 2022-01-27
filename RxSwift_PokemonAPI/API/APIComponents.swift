//
//  APIComponents.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/26.
//

import Foundation
import Alamofire

enum APIComponents {
    case pokemon_limit
    
    var path: String {
        switch self {
        case .pokemon_limit:
            return "pokemon/1"
        }
    }
    
    public static var basePath = "https://pokeapi.co/api/v2/"
    
    public static var header: HTTPHeaders? {
        return [
            "Content-Type":"application/json",
            "Accept-Language": "ja"
        ]
    }
}
