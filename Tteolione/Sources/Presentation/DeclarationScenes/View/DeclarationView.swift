//
//  DeclarationView.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit
import SnapKit

final class DeclarationView: BaseView {
    
    private let titleLabel = BoldLabel(text: "신고",
                                       font: Font.Andong30,
                                       color: .myAppBlack)
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DeclaractionTableViewCell.self,
                           forCellReuseIdentifier: DeclaractionTableViewCell.identifier)
        tableView.backgroundColor = .myAppLightGray2
        tableView.rowHeight = Device.screenHeight * 0.12
        return tableView
    }()
    
    override func configureHierarchy() {
        [titleLabel, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
