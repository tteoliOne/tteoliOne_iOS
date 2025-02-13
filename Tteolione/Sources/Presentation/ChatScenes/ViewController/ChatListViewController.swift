//
//  ChatListViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import ReactorKit
import RxCocoa

final class ChatListViewController: BaseViewController<ChatListView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ChatListCoordinatorDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension ChatListViewController: View {
    
    func bind(reactor: ChatListReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ChatListReactor) {
        self.rx.viewWillAppear
            .map { _ in ChatListReactor.Action.fetchChatList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(ChatListDTO.self)
            .map { ChatListReactor.Action.tableIndexTap($0.chatNo, $0.productNo) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ChatListReactor) {
        reactor.state
            .map { $0.setChatListDTO ?? [] }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ChatListTableViewCell.identifier,
                cellType: ChatListTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ChatListReactor) {
        reactor.state
            .compactMap { state -> (Int, Int)? in
                guard state.isTableIndexTapped,
                      let chatNo = state.selectedChatNo,
                      let productNo = state.selectedProductNo else {
                    return nil
                }
                return (chatNo, productNo)
            }
            .bind(with: self) { owner, chatData in
                let (chatNo, productNo) = chatData
                owner.delegate?.showChatView(chatId: chatNo, productId: productNo)
            }
            .disposed(by: disposeBag)
    }

}

extension ChatListViewController: DelegateOwner {
    typealias Delegate = ChatListCoordinatorDelegate
}
