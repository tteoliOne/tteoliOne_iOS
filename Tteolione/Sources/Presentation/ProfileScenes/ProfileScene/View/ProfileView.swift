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
    
    //MARK: - 프로필 변경시 화면
    let profileSetButton = CommonButton(title: .profile,
                                        corner: 0,
                                        backgroundColor: .clear,
                                        textColor: .black,
                                        font: Font.Andong20)
    private let setNicknameLabel = AndongLabel(text: AppText.Etc.nickname,
                                               color: .myAppBlack)
    private let setNicknameView = ShadowView(color: .white,
                                             corner: (Device.screenHeight * 0.06) / 2,
                                             shadowColor: UIColor(red: 0x58/255.0,
                                                                  green: 0x8F/255.0,
                                                                  blue: 0x11/255.0,
                                                                  alpha: 1.0).cgColor)
    private let setNicknameTextField = CommonTextField()
    private let setNickErrorLabel = RegularLabel(text: "닉네임 중복입니다!!",
                                              font: Font.regular13,
                                              color: .myAppRed)
    private let setIntroLabel = AndongLabel(text: AppText.Etc.intro,
                                            color: .myAppBlack)
    private let setIntroView = ShadowView(color: .white,
                                          corner: (Device.screenHeight * 0.06) / 2,
                                          shadowColor: UIColor(red: 0x58/255.0,
                                                               green: 0x8F/255.0,
                                                               blue: 0x11/255.0,
                                                               alpha: 1.0).cgColor)
    private let setIntroTextField = CommonTextField()
    let setButton = CommonButton(title: .set,
                                 corner: 24,
                                 backgroundColor: .myAppMain,
                                 textColor: .white)
    
    override func configureHierarchy() {
        [profileFieldView, listView,
         logOutButton, slash,
         withdrawalButton].forEach { addSubview($0) }
        
        [profileShadowView, nicknameView,
         thumbView, oneLinerLabel,
         profileSetButton, setNicknameLabel,
         setNicknameView, setNickErrorLabel,
         setIntroLabel, setIntroView,
         setButton].forEach { profileFieldView.addSubview($0) }
        [setNicknameTextField].forEach { setNicknameView.addSubview($0) }
        [setIntroTextField].forEach { setIntroView.addSubview($0) }
        
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
        setNicknameTextField.textAlignment = .center
        setIntroTextField.textAlignment = .center
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
    
    private func updateVisibility(hiddenViews: [UIView], visibleViews: [UIView]) {
        hiddenViews.forEach { $0.isHidden = true }
        visibleViews.forEach { $0.isHidden = false }
    }

    func resetProfileField() {
        UIView.animate(withDuration: 0.3, animations: {
            self.profileFieldView.snp.updateConstraints { make in
                make.height.equalTo(Device.screenHeight * 0.75)
            }

            self.profileShadowView.snp.remakeConstraints { make in
                make.size.equalTo(Device.screenWidth * 0.33)
                make.centerX.equalTo(self.profileFieldView)
                make.top.equalTo(self.profileFieldView).inset(24)
            }

            self.profileSetButton.snp.makeConstraints { make in
                make.top.equalTo(self.profileShadowView.snp.bottom).offset(16)
                make.centerX.equalTo(self.profileFieldView)
            }

            self.setNicknameLabel.snp.makeConstraints { make in
                make.top.equalTo(self.profileSetButton.snp.bottom).offset(20)
                make.centerX.equalTo(self.profileFieldView)
            }

            self.setNicknameView.snp.makeConstraints { make in
                make.top.equalTo(self.setNicknameLabel.snp.bottom).offset(8)
                make.centerX.equalTo(self.profileFieldView)
                make.height.equalTo(Device.screenHeight * 0.06)
                make.width.equalTo(Device.screenWidth * 0.5)
            }

            self.setNicknameTextField.snp.makeConstraints { make in
                make.edges.equalTo(self.setNicknameView)
            }

            self.setNickErrorLabel.snp.makeConstraints { make in
                make.centerX.equalTo(self.profileFieldView)
                make.top.equalTo(self.setNicknameView.snp.bottom).offset(8)
            }
            
            self.setIntroLabel.snp.makeConstraints { make in
                make.top.equalTo(self.setNickErrorLabel.snp.bottom).offset(20)
                make.centerX.equalTo(self.profileFieldView)
            }

            self.setIntroView.snp.makeConstraints { make in
                make.top.equalTo(self.setIntroLabel.snp.bottom).offset(12)
                make.height.equalTo(Device.screenHeight * 0.06)
                make.horizontalEdges.equalTo(self.profileFieldView).inset(28)
                make.centerX.equalTo(self.profileFieldView)
            }

            self.setIntroTextField.snp.makeConstraints { make in
                make.edges.equalTo(self.setIntroView)
            }

            self.setButton.snp.makeConstraints { make in
                make.centerX.equalTo(self.profileFieldView)
                make.bottom.equalTo(self.listView.snp.top).offset(-24)
                make.height.equalTo(48)
                make.horizontalEdges.equalTo(self.profileFieldView).inset(20)
            }

            let hiddenViews = [
                self.nicknameView, self.thumbView, self.oneLinerLabel,
                self.logOutButton, self.slash, self.withdrawalButton
            ]
            
            let visibleViews: [UIView] = [
                self.setButton, self.setIntroView, self.setIntroLabel,
                self.setNickErrorLabel, self.profileSetButton, self.setNicknameLabel,
                self.setNicknameView
            ]
            self.updateVisibility(hiddenViews: hiddenViews, visibleViews: visibleViews)

            self.layoutIfNeeded()
        })
    }

    func resetProfile() {
        UIView.animate(withDuration: 0.3, animations: {
            self.profileFieldView.snp.updateConstraints { make in
                make.height.equalTo(Device.screenHeight * 0.22)
            }
            
            self.profileShadowView.snp.makeConstraints { make in
                make.size.equalTo(Device.screenWidth * 0.22)
                make.top.equalTo(self.profileFieldView).inset(28)
                make.leading.equalTo(self.profileFieldView).inset(20)
            }
            
            let visibleViews = [
                self.nicknameView, self.thumbView, self.oneLinerLabel,
                self.logOutButton, self.slash, self.withdrawalButton
            ]
            
            let hiddenViews: [UIView] = [
                self.setButton, self.setIntroView, self.setIntroLabel,
                self.setNickErrorLabel, self.profileSetButton, self.setNicknameLabel,
                self.setNicknameView
            ]

            self.updateVisibility(hiddenViews: hiddenViews, visibleViews: visibleViews)
            self.layoutIfNeeded()
        })
    }

}
