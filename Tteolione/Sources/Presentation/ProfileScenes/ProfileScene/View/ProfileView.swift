//
//  ProfileView.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    private let profileFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    private let profileMyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "31photo")
        imageView.layer.cornerRadius = (UIScreen.main.bounds.width * 0.22) / 2
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = false
        imageView.layer.shadowColor = UIColor(red: 0x58/255.0, green: 0x8F/255.0, blue: 0x11/255.0, alpha: 1.0).cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        imageView.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width * 0.22).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.22).isActive = true
        return imageView
    }()
    
    private let nicknameView = ShadowView(corner: 20,
                                          shadowColor: UIColor.myAppMain.cgColor)
    private let thumbView = ShadowView(corner: 20,
                                          shadowColor: UIColor.myAppMain.cgColor)
    private let nicknameLabel = AndongLabel(text: AppText.Etc.nickname,
                                            color: .myAppMain)
    private let nickname = AndongLabel(text: "닉네임",
                                       font: Font.Andong15,
                                       color: .myAppBlack)
    private let thumbLabel = AndongLabel(text: AppText.Etc.thumb,
                                         color: .myAppMain)
    private let thumbCount = AndongLabel(text: "3",
                                         font: Font.Andong15,
                                         color: .myAppBlack)
    private let oneLinerLabel = RegularLabel(text: "한줄 소개",
                                             color: .myAppBlack)
    private let listView = ShadowView(color: .myAppMain,
                                      corner: 20)
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileListTableViewCell.self,
                           forCellReuseIdentifier: ProfileListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 320
        return tableView
    }()
    private let logOutButton = CommonButton(title: .logout,
                                            corner: 0,
                                            backgroundColor: .clear,
                                            textColor: .myAppDarkGray,
                                            font: Font.regular17)
    private let slash = SlashLabel(font: Font.regular20)
    private let withdrawalButton = CommonButton(title: .withdrawal,
                                            corner: 0,
                                            backgroundColor: .clear,
                                            textColor: .myAppDarkGray,
                                            font: Font.regular17)
    
    override func configureHierarchy() {
        [profileFieldView, listView,
         logOutButton, slash,
         withdrawalButton].forEach { addSubview($0) }
        [profileMyImage, nicknameView,
         thumbView, oneLinerLabel].forEach { profileFieldView.addSubview($0) }
        [nicknameLabel, nickname].forEach { nicknameView.addSubview($0) }
        [thumbLabel, thumbCount].forEach { thumbView.addSubview($0) }
        [tableView].forEach { listView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileFieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        profileMyImage.snp.makeConstraints { make in
            make.top.equalTo(profileFieldView).inset(30)
            make.leading.equalTo(profileFieldView).inset(20)
            make.size.equalTo(100)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(profileMyImage).inset(8)
            make.leading.equalTo(profileMyImage.snp.trailing).offset(12)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(nicknameView)
            make.top.equalTo(nicknameView).inset(4)
        }
        
        nickname.snp.makeConstraints { make in
            make.centerX.equalTo(nicknameView)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        }
        
        thumbView.snp.makeConstraints { make in
            make.top.equalTo(profileMyImage).inset(8)
            make.leading.equalTo(nicknameView.snp.trailing).offset(12)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        thumbLabel.snp.makeConstraints { make in
            make.centerX.equalTo(thumbView)
            make.top.equalTo(thumbView).inset(4)
        }
        
        thumbCount.snp.makeConstraints { make in
            make.centerX.equalTo(thumbView)
            make.top.equalTo(thumbLabel.snp.bottom).offset(8)
        }
        
        oneLinerLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom).offset(12)
            make.leading.equalTo(nicknameView)
            make.trailing.equalTo(thumbView)
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(profileFieldView.snp.bottom).offset(-20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.height.equalTo(400)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(listView).inset(20)
        }
        
        slash.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.trailing.equalTo(slash.snp.leading).offset(-8)
            make.centerY.equalTo(slash)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.leading.equalTo(slash.snp.trailing).offset(8)
            make.centerY.equalTo(slash)
        }
    }
    
    override func configureView() {
        slash.textColor = .myAppDarkGray
    }
}
