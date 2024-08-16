//
//  HomeViewController.swift
//  RxSwiftExample
//
//  Created by Jervy Umandap on 8/16/24.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga", "Philippines", "Japan", "China", "USA", "Singapore"] // Our mocked API data source
    let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupBindings()
    }
    
    func setupBindings() {
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // Filter for non-empty query, If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
//                self.setNeedsUpdateContentUnavailableConfiguration()
            })
            .disposed(by: disposeBag)
    }
    
//    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
//        super.updateContentUnavailableConfiguration(using: state)
//        if shownCities.isEmpty {
////            var config = UIContentUnavailableConfiguration.empty()
////            config.image = .init(systemName: "flag.circle")
////            config.text = "No results found"
////            // config.secondaryText = "This user has no followers, go follow them."
////            contentUnavailableConfiguration = config
//            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
//        } else {
//            contentUnavailableConfiguration = nil
//        }
//    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = shownCities[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item
        content.secondaryText = "SecondaryText"
        content.image = UIImage(systemName: "flag.circle.fill")
        cell.contentConfiguration = content
        return cell
    }
    
}
