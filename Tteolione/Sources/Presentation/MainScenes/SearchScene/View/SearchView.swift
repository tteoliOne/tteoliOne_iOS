//
//  SearchView.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    let searchBar = SearchBar()
    let childContainerView = UIView()
    
    override func configureHierarchy() {
        addSubview(childContainerView)
    }
    
    override func configureLayout() {
        childContainerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}

extension SearchView {
    
    func setChildView(_ childView: UIView) {
        childContainerView.subviews.forEach { $0.removeFromSuperview() }
        childContainerView.addSubview(childView)
        childView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
