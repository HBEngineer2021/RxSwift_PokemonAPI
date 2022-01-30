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
    
    var item: Observable<[ViewModels]>?
    
    let apiRequest = APIRequest()
    
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
        tapTableViewCell()
    }
    
    func request() {
        let path = "pokemon/1"
        let params: Parameters? = [:]/*= ["limit":"100",
         "offset":"200"]*/
        apiRequest.get(path: path, prams: params!, type: Pokemon.self)
            .map { response in
                self.item = .just([ViewModels(id: response.id, name: response.name, image: response.sprites.frontDefault)])
            }
            .bind(onNext: {
                self.setupBindings()
            })
            .disposed(by: disposeBag)
    }
    
    func setupBindings() {
        
        item?.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            cell.textLabel?.text = "\(element.id). " + element.name
            cell.imageView?.image = UIImage.init(url: element.image)
            cell.backgroundColor = .white
        }
        .disposed(by: disposeBag)
    }
    
    func tapTableViewCell() {
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            print(indexPath.row)
        })
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

extension UIImage {
   public convenience init(url: String) {
       let url = URL(string: url)
       do {
           let data = try Data(contentsOf: url!)
           self.init(data: data)!
           return
       } catch let err {
           print("Error : \(err.localizedDescription)")
       }
       self.init()
   }
}
