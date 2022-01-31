//
//  RealmDB.swift
//  RxSwift_PokemonAPI
//
//  Created by 小名山 on 2022/01/31.
//

import Foundation
import Realm
import RealmSwift

class PokemonData: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    
}
