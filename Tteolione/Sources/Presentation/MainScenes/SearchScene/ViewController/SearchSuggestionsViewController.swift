//
//  SearchSuggestionsViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

class SearchSuggestionsViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var suggestions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    func updateSearchQuery(_ query: String) {
        suggestions = ["\(query) 1", "\(query) 2", "\(query) 3"]
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
    
}

