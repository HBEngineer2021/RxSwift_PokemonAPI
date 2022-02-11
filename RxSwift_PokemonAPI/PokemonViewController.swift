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
import RxDataSources

class PokemonViewController: UIViewController {
    
    var item: Observable<[ViewModels]>?
    
    var items: BehaviorRelay<[SectionModel]> = BehaviorRelay(value: [])
    
    var itemList = [ViewModels]()
    
    let disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        ds, tv, ip, item in
        let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
        cell.textLabel?.text = "\(item.id).　" + item.name
        cell.textLabel?.textColor = .black
        cell.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cell.imageView?.image = UIImage.init(url: item.image)
        cell.backgroundColor = .white
        return cell
    },
    titleForHeaderInSection: {
        ds, index in
        return ds.sectionModels[index].header
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        lauout()
        tapTableViewCell()
        generate()
        self.items
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    /// APIを叩く
    func getData(num: Int) {
        let path = "pokemon/\(num)"
        APIRequest.shared.getPokeApiData(path: path)
            .bind(onNext: { response in
                let newModel = [SectionModel(header: "", num: num,
                                             items: [ViewModels(id: response.id, name: response.name, image: response.sprites.frontDefault)])]
                let newValue = self.items.value + newModel
                self.items.accept(newValue)
                print(self.items.value)
            }).disposed(by: disposeBag)
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
        }).disposed(by: self.disposeBag)
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
