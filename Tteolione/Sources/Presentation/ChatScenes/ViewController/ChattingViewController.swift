//
//  ChattingViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import ReactorKit
import RxCocoa
import UIKit

final class ChattingViewController: BaseViewController<ChattingView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ChattingCoordinatorDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reactor?.action.onNext(.socketDisconnect)
    }
}

extension ChattingViewController: View {
    
    func bind(reactor: ChattingReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ChattingReactor) {
        reactor.action.onNext(.socketConnect)
        
        rootView.sendButton.rx.tap
            .withLatestFrom(rootView.messageTextView.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] _ in
                self?.rootView.messageTextView.text = ""
                self?.reactor?.action.onNext(.updateSendButtonState(""))
            })
            .map { ChattingReactor.Action.sendMessage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.messageTextView.rx.text.orEmpty
            .map { ChattingReactor.Action.updateSendButtonState($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ChattingReactor) {
        reactor.state.map { $0.isConnected }
            .distinctUntilChanged()
            .subscribe(onNext: { isConnected in
                print("✅ WebSocket 연결 상태: \(isConnected)")
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.messages }
            .bind(to: rootView.tableView.rx.items(cellIdentifier: ChatMessageCell.identifier,
                                                  cellType: ChatMessageCell.self)
            ) { _, message, cell in
                cell.configure(with: message)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSendButtonEnabled }
            .bind(to: rootView.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSendButtonEnabled }
            .map { $0 ? UIColor.myAppMain : UIColor.myAppLightGray2 }
            .bind(to: rootView.sendButton.rx.tintColor)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.messages.count }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
//                self?.rootView.tableView.scrollToBottom(animated: true)
                self?.rootView.tableView.reloadData()
                        self?.rootView.tableView.layoutIfNeeded() // 🚨 레이아웃 강제 업데이트
                        self?.rootView.tableView.scrollToBottom(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ChattingReactor) {
        reactor.state.map { $0.isViewDisappeared }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension ChattingViewController: DelegateOwner {
    typealias Delegate = ChattingCoordinatorDelegate
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let numberOfSections = self.numberOfSections
            guard numberOfSections > 0 else { return }
            
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            guard numberOfRows > 0 else { return }
            
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
