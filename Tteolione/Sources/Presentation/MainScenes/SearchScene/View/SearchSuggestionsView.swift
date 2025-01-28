//
//  SearchSuggestionsView.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit
import SnapKit

final class SearchSuggestionsView: BaseView {
    
    let tableView = UITableView()
    
    override func configureHierarchy() {
        [tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
    }
    
}
