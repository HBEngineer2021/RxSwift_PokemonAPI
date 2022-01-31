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
    
    var rx_model: BehaviorRelay<ViewModels>?
    var rx_withOldValue: Observable<(new: ViewModels, old: ViewModels)>?
    
    init(_ model: ViewModels) {
        rx_model = BehaviorRelay(value: model)
        rx_withOldValue = 
            
        
    }
}
