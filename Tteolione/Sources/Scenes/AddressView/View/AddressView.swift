//
//  AddressView.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import UIKit
import SnapKit

final class AddressView: BaseView {
    
    let topBarView = TopBarView()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "주소를 입력하세요"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
        return searchBar
    }()
    let myLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("현재 위치에서 주소 찾기", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
        return tableView
    }()
    
    override func configureHierarchy() {
        [topBarView, searchBar,
         myLocationButton, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(myLocationButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
