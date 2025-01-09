//
//  MainView.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 320
        return tableView
    }()
    let postButton = PostButton()
    
    override func configureHierarchy() {
        [tableView, postButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
    }
    
}

extension MainView {
    
    func adjustButtonShape(forScrollOffset offset: CGFloat) {
        DispatchQueue.main.async {
            let isCompact = offset > 100
            
            UIView.animate(withDuration: 0.3) {
                if isCompact {
                    self.postButton.snp.updateConstraints { make in
                        make.width.equalTo(48)
                    }
                    self.postButton.setTitle("", for: .normal)
                } else {
                    self.postButton.snp.updateConstraints { make in
                        make.width.equalTo(120)
                    }
                    self.postButton.setTitle("상품등록", for: .normal)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
}

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        MainViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider{
    static var previews: some View{
        ViewControllerPresentable()
    }
}

#endif
