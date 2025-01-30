//
//  SearchResultsView.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit
import SnapKit

final class SearchResultsView: BaseView {
    
    let searchLabel = AndongLabel(text: "검색 결과",
                                  color: .myAppMain)
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func configureHierarchy() {
        [searchLabel, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        searchLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}
