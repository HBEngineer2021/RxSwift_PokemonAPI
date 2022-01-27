//
//  PokemonRequest.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/27.
//

import Foundation
import Alamofire

enum PokemonRequest: APIBaseRequestProtocol {
    
    typealias ResponseType = PokemonAPIResponse
    
    case get
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }
    
    var path: String {
        return APIComponents.pokemon_limit.path
    }
    
    var parameters: Parameters? {
        return nil
    }
    
}
