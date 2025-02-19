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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
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
        
        reactor.state.map { $0.productData }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView, onNext: { owner, dto in
                owner.configureData(with: dto,
                                    reactor: reactor)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.messages }
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items) { tableView, index, message in
                print(message.type)
                if message.type == .notice {
                    let cell = tableView.dequeueReusableCell(withIdentifier: SystemMessageCell.identifier,
                                                             for: IndexPath(row: index, section: 0)) as! SystemMessageCell
                    cell.configure(with: message.text)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier,
                                                             for: IndexPath(row: index, section: 0)) as! ChatMessageCell
                    cell.configure(with: message)
                    return cell
                }
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.rootView.tableView.reloadData()
                self?.rootView.tableView.layoutIfNeeded()
                self?.rootView.tableView.scrollToBottom(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.requestButtonState }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: rootView, onNext: { owner, state in
                owner.updateRequestButton(state)
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
        
        reactor.state
            .compactMap { state -> Int? in
                guard state.isReviewViewPushed,
                      let productNo = state.productId else {
                    return nil
                }
                return productNo
            }
            .bind(with: self) { owner, productNo in
                owner.delegate?.pushReviewView(productId: productNo)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { state -> (Int, Int)? in
                guard state.pushReportPost,
                      let chatNo = state.chatId,
                      let opponentNo = state.opponentId else {
                    return nil
                }
                return (chatNo, opponentNo)
            }
            .bind(with: self) { owner, chatData in
                let (chatNo, opponentNo) = chatData
                owner.delegate?.showReportView(reportType: .chat,
                                               reportId: chatNo,
                                               opponentId: opponentNo)
            }
            .disposed(by: disposeBag)
    }
}

extension ChattingViewController {
    
    private func setupNavigation() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let menu = createMenu()
        let ellipsisButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis")?.rotate(radians: .pi / 2),
            menu: menu
        )
        ellipsisButton.tintColor = .black
        navigationItem.rightBarButtonItem = ellipsisButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createMenu() -> UIMenu {
        let reportAction = UIAction(
            title: "신고하기",
            image: UIImage(systemName: "exclamationmark.circle")
        ) { [weak self] _ in
            self?.reactor?.action.onNext(.reportPost)
        }
        
        let exitAction = UIAction(
            title: "방 나가기",
            image: UIImage(systemName: "door.right.hand.open"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.reactor?.action.onNext(.exitChatRoomTap)
        }
        
        return UIMenu(title: "", children: [reportAction, exitAction])
    }
    
}

extension ChattingViewController: DelegateOwner {
    typealias Delegate = ChattingCoordinatorDelegate
}
