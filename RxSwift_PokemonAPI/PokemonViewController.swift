//
//  PokemonViewController.swift
//  RxSwift_PokemonAPI
//
//  Created by Motoki Onayama on 2022/01/26.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class PokemonViewController: UIViewController {
    
    var item: Observable<[ViewModels]>? = .just([ViewModels(id: 1, name: "セル", image: ""),
                                                ViewModels(id: 2, name: "セル", image: "")])
    
    let disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        lauout()
        request()
        setupBindings()
    }
    
    func request() {
        let path = "1"
        let prams: Parameters = [:]
        
        _ = APIRequest.shared.get(path: path, prams: prams, type: Pokemon.self) { (response) in
            self.item = .just([ViewModels(id: response.id, name: response.name, image: response.sprites.frontDefault)])
            
        }
    }
    
    func setupBindings() {
        item?.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            cell.textLabel?.text = "\(element.id). " + element.name
            cell.backgroundColor = .black
        }
        .disposed(by: disposeBag)
    }
    
    func lauout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorColor = .black
        let top = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
}
