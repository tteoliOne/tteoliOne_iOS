//
//  ChatMessageCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import UIKit
import SnapKit

final class ChatMessageCell: BaseTableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "31photo")
        imageView.isHidden = true
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.myAppMain.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    private let unreadLabel: UILabel = {
        let label = UILabel()
        label.textColor = .myAppMain
        label.font = Font.regular12
        label.text = "1"
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(unreadLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(32)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.greaterThanOrEqualTo(20)
            make.height.greaterThanOrEqualTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(4)
        }
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        timeLabel.text = message.timestamp
        if message.isMine {
            profileImageView.isHidden = true
                unreadLabel.isHidden = false
            if message.unRead ?? true {
                unreadLabel.isHidden = false
            } else {
                unreadLabel.isHidden = true
            }
            containerView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.trailing.equalToSuperview().offset(-8)
                make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(containerView.snp.leading).offset(-4)
                make.bottom.equalTo(containerView)
            }
            
            unreadLabel.snp.remakeConstraints { make in
                make.leading.equalTo(timeLabel).inset(-8)
                make.centerY.equalTo(timeLabel)
            }
        } else {
            profileImageView.isHidden = false
            unreadLabel.isHidden = true
            profileImageView.image = UIImage(named: "31photo")
            
            if let profilePath = message.opponentProfile, !profilePath.isEmpty {
                let profileURL = URL(fileURLWithPath: profilePath)
                if let imageData = try? Data(contentsOf: profileURL), let image = UIImage(data: imageData) {
                    profileImageView.image = image
                }
            }
            
            profileImageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(8)
                make.bottom.equalTo(containerView)
                make.size.equalTo(30)
            }
            
            containerView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.leading.equalTo(profileImageView.snp.trailing).offset(8)
                make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7)
            }
            
            timeLabel.snp.remakeConstraints { make in
                make.leading.equalTo(containerView.snp.trailing).offset(4)
                make.bottom.equalTo(containerView)
            }
        }
    }
}
