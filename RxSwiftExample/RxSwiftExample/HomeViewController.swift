//
//  HomeViewController.swift
//  RxSwiftExample
//
//  Created by Jervy Umandap on 8/16/24.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Home"
        
        setupRx()
    }
    
    func setupRx() {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCities.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = allCities[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item
        content.secondaryText = "SecondaryText"
        content.image = UIImage(systemName: "person.circle")
        cell.contentConfiguration = content
        return cell
    }
}
