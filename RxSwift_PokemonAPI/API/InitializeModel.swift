//
//  InitializeModel.swift
//  RxSwift_PokemonAPI
//
//  Created by 小名山 on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ViewModel {
    
    var viewList: [ViewModels] = []
    
    var relayItems: BehaviorRelay<[ViewModels]>?
    
    init() {
        relayItems = BehaviorRelay<[ViewModels]>(value: viewList)
    }
}
