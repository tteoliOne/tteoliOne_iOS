//
//  MyProductListView.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import SnapKit

final class MyProductListView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.MyProduct.myShare
        label.font = Font.bold20
        label.textColor = .myAppMain
        return label
    }()
    let backButton = BackButton(size: 24)
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductListTableViewCell.self,
                           forCellReuseIdentifier: ProductListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 140
        return tableView
    }()
    
    override func configureHierarchy() {
        [backButton, titleLabel,
         tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}

extension MyProductListView {
    func setupTitle(with value: StatusType) {
        switch value {
        case .eNew:
            titleLabel.text = AppText.MyProduct.myShare
            
        case .eSoldOut:
            titleLabel.text = AppText.MyProduct.complete
            
        case .saved:
            titleLabel.text = AppText.MyProduct.likeList
        }
    }
}
