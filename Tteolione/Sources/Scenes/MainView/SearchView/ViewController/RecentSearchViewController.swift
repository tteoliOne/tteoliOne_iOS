//
//  RecentSearchViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

class RecentSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var recentSearches: [String] = ["Apple", "Banana", "Carrot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
    
}
