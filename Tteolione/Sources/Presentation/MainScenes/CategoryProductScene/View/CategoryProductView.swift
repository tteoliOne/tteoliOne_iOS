//
//  CategoryProductView.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import UIKit
import SnapKit

final class CategoryProductView: BaseView {
    
    private let categoryLabel = AndongLabel(text: "카테고리",
                                            font: Font.Andong20,
                                            color: .myAppMain)
    let filterButton: CommonButton = {
        let button = CommonButton(title: .filter,
                                  corner: 14,
                                  backgroundColor: .clear,
                                  textColor: .myAppBlack,
                                  font: Font.regular15,
                                  symbol: UIImage(systemName: "chevron.down"),
                                  symbolTintColor: .myAppBlack,
                                  isSymbolLeading: false)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.myAppBlack.cgColor
        return button
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductListTableViewCell.self,
                           forCellReuseIdentifier: ProductListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 140
        return tableView
    }()
    
    override func configureHierarchy() {
        [categoryLabel, filterButton,
         tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(28)
            make.width.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension CategoryProductView {
    func setTitle(_ id: Int) {
        switch id {
        case 1:
            categoryLabel.text = "채소"
        case 2:
            categoryLabel.text = "과일"
        case 3:
            categoryLabel.text = "간편식"
        case 4:
            categoryLabel.text = "정육"
        case 5:
            categoryLabel.text = "수산물"
        case 6:
            categoryLabel.text = "기타"
        default:
            categoryLabel.text = "카테고리"
        }
    }
}
