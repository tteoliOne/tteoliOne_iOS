//
//  ChattingView.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import UIKit
import SnapKit

final class ChattingView: BaseView {
    
    private var buttonAction: (() -> Void)?
    private let inputTopView = UIView()
    private let productImageView: LoadImageView = {
        let imageView = LoadImageView()
        imageView.layer.cornerRadius = ((Device.screenHeight * 0.08) * 0.8) / 3
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.myAppBlack.cgColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let productTitleLabel = BoldLabel(text: "제목",
                                              font: Font.bold20,
                                              color: .myAppBlack)
    private let productPriceLabel = RegularLabel(text: "개당 0원",
                                                 font: Font.regular15,
                                                 color: .myAppRed)
    private let requestButton: CommonButton = {
        let button = CommonButton(title: .requestStart,
                                  corner: 12,
                                  backgroundColor: .myAppMain,
                                  textColor: .white)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
        button.clipsToBounds = false
        
        return button
    }()
    private let boundarView = BoundarView(.myAppBlack)
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatMessageCell.self,
                           forCellReuseIdentifier: ChatMessageCell.identifier)
        tableView.register(SystemMessageCell.self,
                           forCellReuseIdentifier: SystemMessageCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let inputContainerView = UIView()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 16
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func configureHierarchy() {
        [inputTopView, tableView,
         inputContainerView].forEach { addSubview($0) }
        [productImageView, productTitleLabel,
         productPriceLabel, requestButton,
         boundarView].forEach { inputTopView.addSubview($0) }
        [messageTextView, sendButton].forEach { inputContainerView.addSubview($0) }
    }
    
    override func configureLayout() {
        inputTopView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(Device.screenHeight * 0.08)
        }
        
        productImageView.snp.makeConstraints { make in
            make.leading.equalTo(inputTopView).inset(12)
            make.centerY.equalTo(inputTopView)
            make.size.equalTo(Device.screenHeight * 0.08 * 0.8)
        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(productTitleLabel)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
        }
        
        requestButton.snp.makeConstraints { make in
            make.trailing.equalTo(inputTopView).inset(12)
            make.bottom.equalTo(inputTopView).inset(8)
            make.width.equalTo(Device.screenWidth * 0.28)
            make.height.equalTo(32)
        }
        
        boundarView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(inputTopView)
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(inputTopView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50).priority(.high) // 최소 높이 설정, 우선순위 조정
        }

        messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(inputContainerView).offset(12)
            make.top.bottom.equalTo(inputContainerView).inset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(36) // 최소 높이 설정
        }

        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(messageTextView)
            make.trailing.equalTo(inputContainerView).offset(-12)
            make.width.height.equalTo(36)
        }
    }
}

extension ChattingView {
    func configureData(with data: ChatContentDTO, reactor: ChattingReactor?) {
        if let imageUrl = URL(string: data.productImage) {
            productImageView.loadImage(from: imageUrl)
        } else {
            productImageView.image = nil
        }
        productTitleLabel.text = data.title
        productPriceLabel.text = "개당 \(FormatterManager.shared.numberFormatter(data.sharePrice))원"

        configureRequestButton(isMine: data.checkSeller,
                               status: data.soldStatus,
                               checkReservation: data.checkReservation,
                               checkReview: data.checkReview,
                               productId: data.productId,
                               chatRoomId: reactor?.currentState.chatId ?? 0,
                               opponentId: data.opponentId,
                               reactor: reactor)
    }
    
    func updateRequestButton(_ state: RequestButtonState) {
        print("state: \(state)")
        switch state {
        case .request:
            requestButton.setTitle("요청하기", for: .normal)
            requestButton.isEnabled = true
            requestButton.backgroundColor = .myAppMain
            
        case .approve:
            requestButton.setTitle("승인하기", for: .normal)
            requestButton.isEnabled = true
            requestButton.backgroundColor = .myAppMain
            
        case .pending:
            requestButton.setTitle("요청중..", for: .normal)
            requestButton.isEnabled = false
            requestButton.backgroundColor = .myAppDarkGray
            
        case .rejectApprove:
            requestButton.setTitle("승인하기", for: .normal)
            requestButton.isEnabled = false
            requestButton.backgroundColor = .myAppDarkGray
            
        case .complete:
            requestButton.setTitle("공유 완료", for: .normal)
            requestButton.isEnabled = false
            requestButton.backgroundColor = .myAppDarkGray
            
        case .review:
            requestButton.setTitle("후기 쓰기", for: .normal)
            requestButton.isEnabled = true
            requestButton.backgroundColor = .myAppMain
        }

        DispatchQueue.main.async {
            self.requestButton.layoutIfNeeded()
        }
    }
    
    private func configureRequestButton(isMine: Bool,
                                        status: String,
                                        checkReservation: Bool,
                                        checkReview: Bool,
                                        productId: Int,
                                        chatRoomId: Int,
                                        opponentId: Int,
                                        reactor: ChattingReactor?) {
        let disabledColor = UIColor.myAppDarkGray
        let enabledColor = UIColor.myAppMain
        
        var action: (() -> Void)? = nil
        
        if isMine {
            if status == "eNew" {
                requestButton.setTitle("승인하기", for: .normal)
                requestButton.isEnabled = false
            } else if status == "eReservation" {
                requestButton.setTitle("승인하기", for: .normal)
                requestButton.isEnabled = true
                action = { [weak self] in
                    self?.showApprovalAlert(productId: productId, chatRoomId: chatRoomId, buyerId: opponentId, reactor: reactor)
                }
            } else {
                requestButton.setTitle("공유완료", for: .normal)
                requestButton.isEnabled = false
            }
        } else {
            if status == "eNew" {
                requestButton.setTitle("요청하기", for: .normal)
                requestButton.isEnabled = true
                action = { [weak self] in
                    self?.showRequestAlert(productId: productId, chatRoomId: chatRoomId, reactor: reactor)
                }
            } else if status == "eReservation" {
                if checkReservation {
                    requestButton.setTitle("요청중...", for: .normal)
                    requestButton.isEnabled = false
                } else {
                    requestButton.setTitle("공유중..", for: .normal)
                    requestButton.isEnabled = false
                }
            } else {
                if checkReview {
                    requestButton.setTitle("공유완료", for: .normal)
                    requestButton.isEnabled = false
                } else {
                    requestButton.setTitle("후기쓰기", for: .normal)
                    requestButton.isEnabled = true
                    action = { [weak self] in
                        self?.showReviewAlert(productId: productId, reactor: reactor)
                    }
                }
            }
        }
        
        requestButton.backgroundColor = requestButton.isEnabled ? enabledColor : disabledColor
        requestButton.setTitleColor(.white, for: .normal)
        
        if let action = action {
            requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
            self.buttonAction = action
        }
    }
    
    @objc private func requestButtonTapped() {
        buttonAction?()
    }
}

extension ChattingView {
    private func showRequestAlert(productId: Int,
                                  chatRoomId: Int,
                                  reactor: ChattingReactor?) {
        let alertController = UIAlertController(title: "공유완료 요청",
                                                message: "요청을 보내시겠습니까?",
                                                preferredStyle: .alert)
        alertController.view.tintColor = .myAppMain
        let confirmAction = UIAlertAction(title: "요청하기",
                                          style: .default) { _ in
            reactor?.action.onNext(.fetchPutRequest(productId: productId,
                                                    chatRoomId: chatRoomId))
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        presentAlert(alertController)
    }
    
    private func showApprovalAlert(productId: Int,
                                   chatRoomId: Int,
                                   buyerId: Int,
                                   reactor: ChattingReactor?) {
        let alertController = UIAlertController(title: "공유완료 요청 승인",
                                                message: "요청을 승인하시겠습니까?",
                                                preferredStyle: .alert)
        alertController.view.tintColor = .myAppMain
        let approveAction = UIAlertAction(title: "승인하기",
                                          style: .default) { _ in
            reactor?.action.onNext(.fetchPutApprove(buyerId: buyerId,
                                                    productId: productId,
                                                    chatRoomId: chatRoomId))
        }
        
        let rejectAction = UIAlertAction(title: "거절하기",
                                         style: .destructive) { _ in
            reactor?.action.onNext(.fetchPutReject(buyerId: buyerId,
                                                   productId: productId,
                                                   chatRoomId: chatRoomId))
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(approveAction)
        alertController.addAction(rejectAction)
        alertController.addAction(cancelAction)
        presentAlert(alertController)
    }
    
    private func showReviewAlert(productId: Int,
                                 reactor: ChattingReactor?) {
        let alertController = UIAlertController(title: "후기작성",
                                                message: "후기를 작성하시겠습니까?",
                                                preferredStyle: .alert)
        alertController.view.tintColor = .myAppMain
        let confirmAction = UIAlertAction(title: "작성하기",
                                          style: .default) { _ in
            reactor?.action.onNext(.pushReviewView(productId: productId))
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        presentAlert(alertController)
    }
    
    private func presentAlert(_ alertController: UIAlertController) {
        if let viewController = self.findViewController() {
            viewController.present(alertController,
                                   animated: true,
                                   completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
