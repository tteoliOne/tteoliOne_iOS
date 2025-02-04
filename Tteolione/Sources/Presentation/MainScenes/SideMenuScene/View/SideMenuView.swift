//
//  SideMenuView.swift
//  Tteolione
//
//  Created by 전준영 on 2/4/25.
//

import UIKit
import SnapKit

final class SideMenuView: BaseView {
    
    let xButton = XButton(color: .myAppBlack, systemName: "multiply.circle.fill")
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SideMenuTableViewCell.self,
                           forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .myAppSideMenu
        tableView.rowHeight = 100
        return tableView
    }()
    
    override func configureHierarchy() {
        [xButton, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.size.equalTo(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
