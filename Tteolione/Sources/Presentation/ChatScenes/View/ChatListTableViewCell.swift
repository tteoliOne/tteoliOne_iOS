//
//  ChatListTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import UIKit
import SnapKit
import RxSwift

final class ChatListTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    private let containerView = ShadowView(corner: 32,
                                           borderWidth: 1,
                                           borderColor: UIColor.myAppMain.cgColor)
    private let profileImageView: LoadImageView = {
        let imageView = LoadImageView()
        imageView.layer.cornerRadius = Device.screenWidth / 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.myAppBlack.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let nicknameLabel: BoldLabel = {
        let label = BoldLabel(text: "",
                              font: Font.bold20,
                              color: .myAppBlack)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    private let titleLabel: RegularLabel = {
        let label = RegularLabel(text: "",
                                 font: Font.regular15,
                                 color: .myAppLightGray2)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    private let lastMessageLabel: BoldLabel = {
        let label = BoldLabel(text: "",
                              color: .myAppDarkGray)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    private let timeLabel: RegularLabel = {
        let label = RegularLabel(text: "",
                                 font: Font.regular13,
                                 color: .myAppDarkGray)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        return label
    }()
    private let unReadView: UIView = {
        let view = UIView()
        view.backgroundColor = .myAppMain
        view.layer.cornerRadius = Device.screenWidth * 0.05 / 2
        return view
    }()
    private let unReadCountLabel: RegularLabel = {
        let label = RegularLabel(text: "",
                                 font: Font.regular13,
                                 color: .white)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        return label
    }()
    
    override func configureHierarchy() {
        [containerView].forEach { contentView.addSubview($0) }
        [profileImageView, nicknameLabel,
         titleLabel, lastMessageLabel,
         unReadView, timeLabel].forEach { containerView.addSubview($0) }
        [unReadCountLabel].forEach { unReadView.addSubview($0) }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(containerView).inset(12)
            make.centerY.equalTo(containerView)
            make.size.equalTo(Device.screenWidth / 6)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
            make.bottom.equalTo(nicknameLabel)
            make.width.equalTo(Device.screenWidth * 0.4)
        }
        
        lastMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView).inset(4)
            make.leading.equalTo(nicknameLabel)
            make.width.equalTo(containerView.snp.width).multipliedBy(0.6)
        }
        
        unReadView.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView).inset(12)
            make.size.equalTo(Device.screenWidth * 0.05)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(unReadView)
            make.bottom.equalTo(unReadView.snp.top).offset(-8)
        }
        
        unReadCountLabel.snp.makeConstraints { make in
            make.center.equalTo(unReadView)
        }
    }
}

extension ChatListTableViewCell {
    func configure(with data: ChatListDTO) {
        if let imageUrl = URL(string: data.participant.profile) {
            profileImageView.loadImage(from: imageUrl)
        } else {
            profileImageView.image = nil
        }
        nicknameLabel.text = data.participant.username
        titleLabel.text = data.productTitle
        lastMessageLabel.text = data.latestMessage?.context
        timeLabel.text = FormatterManager.shared.getChatListTimeFormat(from: Int64(data.latestMessage?.sendAt ?? -1))
        switch data.unReadCount {
        case 0:
            unReadView.isHidden = true
            
        case 1...:
            unReadView.isHidden = false
            unReadCountLabel.text = data.unReadCount.description
        default:
            unReadView.isHidden = true
        }
    }
}
