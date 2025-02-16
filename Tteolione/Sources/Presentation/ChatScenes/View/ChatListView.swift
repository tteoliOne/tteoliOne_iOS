//
//  ChatListView.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import UIKit
import SnapKit

final class ChatListView: BaseView {
    
    private let chatListLabel = AndongLabel(text: "채팅 목록",
                                            font: Font.Andong25,
                                            color: .myAppMain)
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatListTableViewCell.self,
                           forCellReuseIdentifier: ChatListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = Device.screenHeight * 0.14
        return tableView
    }()
    
    override func configureHierarchy() {
        [chatListLabel, tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        chatListLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(chatListLabel.snp.bottom).offset(28)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
