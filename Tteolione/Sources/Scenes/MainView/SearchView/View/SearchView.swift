//
//  SearchView.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    private let containerView = UIView()
    
    override func configureHierarchy() {
        addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}

extension SearchView {
    
    func setChildView(_ childView: UIView) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(childView)
        childView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
