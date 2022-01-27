//
//  Models.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/27.
//

import Foundation

struct PokemonAPIResponse: Decodable {
    var data: [Pokemon]?
    var result: Bool = false
}

struct Pokemon: Decodable {
    var id: Int
    var name: String
    var sprites: Sprites
    var typeList: [TypeList]
    struct Sprites: Decodable {
        var frontDefault: String
        private enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    struct TypeList: Decodable {
        var type: Type
        struct `Type`: Decodable {
            var name = "name"
            private enum CodingKeys: String, CodingKey {
                case name = "name"
            }
        }
        private enum CodingKeys: String, CodingKey {
            case type = "type"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case sprites = "sprites"
        case typeList = "types"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        sprites = try container.decode(Sprites.self, forKey: .sprites)
        typeList = try container.decode([TypeList].self, forKey: .typeList)
        id = Int(try container.decode(String.self, forKey: .id))!
    }
}

struct ViewModels {
    var id: Int
    var name: String
    var image: String
}
