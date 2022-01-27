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
    
    let list = ["セル"]
    
    let disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        lauout()
        apiCall()
    }
    
    func lauout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorColor = .gray
        let top = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func apiCall() {
        APIClient.call(PokemonRequest.get, disposeBag,
                       onSuccess: { responese in
                        print("成功", responese.data?.debugDescription)
                        print("成功", responese.result)
                       },
                       onError: { error in
                        print("失敗", error.localizedDescription)
                       })
    }
    
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = list[indexPath.row]
        cell?.backgroundColor = .black
        cell?.textLabel?.textColor = .white
        return cell!
    }
    
}
