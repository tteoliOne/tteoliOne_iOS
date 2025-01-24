//
//  ProfileView.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    private let profileFieldView = ShadowView()
    private let profileShadowView = ShadowView(color: .white,
                                               corner: (Device.screenWidth * 0.22) / 2,
                                               shadowColor: UIColor(red: 0x58/255.0,
                                                                    green: 0x8F/255.0,
                                                                    blue: 0x11/255.0,
                                                                    alpha: 1.0).cgColor)
    private let profileMyImage = CircleImageView(joinImage: .setProfile,
                                                 corner: (Device.screenWidth * 0.22) / 2,
                                                 border: 1)
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
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileListTableViewCell.self,
                           forCellReuseIdentifier: ProfileListTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .myAppMain
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
        [profileShadowView, nicknameView,
         thumbView, oneLinerLabel].forEach { profileFieldView.addSubview($0) }
        [profileMyImage].forEach { profileShadowView.addSubview($0) }
        [nicknameLabel, nickname].forEach { nicknameView.addSubview($0) }
        [thumbLabel, thumbCount].forEach { thumbView.addSubview($0) }
        [tableView].forEach { listView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileFieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(Device.screenHeight * 0.22)
        }
        
        profileShadowView.snp.makeConstraints { make in
            make.top.equalTo(profileFieldView).inset(28)
            make.leading.equalTo(profileFieldView).inset(20)
            make.size.equalTo(Device.screenWidth * 0.22)
        }
        
        profileMyImage.snp.makeConstraints { make in
            make.edges.equalTo(profileShadowView)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(profileMyImage).inset(8)
            make.leading.equalTo(profileMyImage.snp.trailing).offset(12)
            make.height.equalTo(profileShadowView.snp.height).multipliedBy(0.7)
            make.width.equalTo(Device.screenWidth * 0.3)
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
            make.height.equalTo(profileShadowView.snp.height).multipliedBy(0.7)
            make.width.equalTo(Device.screenWidth * 0.3)
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
            make.top.equalTo(nicknameView.snp.bottom).offset(16)
            make.leading.equalTo(nicknameView)
            make.trailing.equalTo(thumbView)
        }
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(profileFieldView.snp.bottom).offset(-32)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(Device.screenHeight * 0.44)
        }
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(listView).inset(20)
            make.horizontalEdges.equalTo(listView).inset(20)
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
        tableView.rowHeight = ((Device.screenHeight * 0.44) - 40) / 5
    }
}

extension ProfileView {
    
    func setupViews(with value: UserProfileDTO) {
        if let imageUrl = URL(string: value.profile) {
            profileMyImage.loadImage(from: imageUrl)
        } else {
            profileMyImage.image = nil
        }
        nickname.text = value.nickname
        oneLinerLabel.text = value.intro ?? "소개글이 없습니다"
        thumbCount.text = "\(value.thumbsUpScore)"
    }
    
}
