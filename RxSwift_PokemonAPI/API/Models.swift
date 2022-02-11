//
//  Models.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/27.
//

import Foundation
import RxDataSources

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
}

struct PokemonAPI: Decodable {
    var results: [Results]
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct Results: Decodable, Identifiable {
    var id = UUID()
    var name: String
    var url: String
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}


struct ViewModels: Decodable {
    var id: Int
    var name: String
    var image: String
}

struct SectionModel {
    var header: String
    var num: Int
    var items: [ViewModels]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [ViewModels]) {
        self = original
        self.items = items
    }
}
