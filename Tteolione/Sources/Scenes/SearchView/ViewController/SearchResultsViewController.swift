//
//  SearchResultsViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func performSearch(with query: String) {
        results = ["Result for \(query) 1", "Result for \(query) 2", "Result for \(query) 3"]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
    
}
