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
        tapTableViewCell()
        generate()
    }
    
    /// APIを叩く
    func getData(num: Int) {
        let path = "pokemon/\(num)"
        let params: Parameters? = [:]
        apiRequest.get(path: path, prams: params!, type: Pokemon.self)
            .map { response in
                self.item = .just([ViewModels(id: response.id, name: response.name, image: response.sprites.frontDefault)])
                print(response.id)
            }
            .bind(onNext: {
                //self.setupBindings()
            })
            .disposed(by: disposeBag)
    }
    
    // - TODO: TableViewの更新処理が反映されていない
    func setupBindings() {
        item?.asDriver(onErrorDriveWith: Driver.empty()).drive(tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            //bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            cell.textLabel?.text = "\(element.id).　" + element.name
            cell.textLabel?.textColor = .black
            cell.heightAnchor.constraint(equalToConstant: 100).isActive = true
            cell.imageView?.image = UIImage.init(url: element.image)
            cell.backgroundColor = .white
        }
        .disposed(by: disposeBag)
    }
    
    /// セル押下時の処理
    func tapTableViewCell() {
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            print(indexPath.row)
        })
            .disposed(by: disposeBag)
    }
    
    /// ストリームでのfor文
    func generate() {
        let obj = Observable.generate(initialState: 1, condition: { $0 <= 100 }) { $0 + 1 }
        obj.bind(onNext: { i in
            self.getData(num: i)
        })
        .disposed(by: disposeBag)
    }
    
    /// tableViewのレイアウトを調整
    func lauout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorColor = .black
        tableView.separatorInset = .zero
        let top = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
}

/// URLを画像データに変換
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
