//
//  ProfileSettingView.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import UIKit
import SnapKit

final class ProfileSettingView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.MyProduct.profileSetting
        label.font = Font.bold20
        label.textColor = .myAppMain
        return label
    }()
    let backButton = BackButton(size: 24)
    private let profileShadowView = ShadowView(color: .white,
                                               corner: (Device.screenHeight * 0.20) / 2,
                                               shadowColor: UIColor(red: 0x58/255.0,
                                                                    green: 0x8F/255.0,
                                                                    blue: 0x11/255.0,
                                                                    alpha: 1.0).cgColor)
    private let profileMyImage = CircleImageView(joinImage: .setProfile,
                                                 corner: (Device.screenHeight * 0.20) / 2,
                                                 border: 1)
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
    let setNicknameTextField = CommonTextField()
    private let setIntroLabel = AndongLabel(text: AppText.Etc.intro,
                                            color: .myAppBlack)
    private let setIntroView = ShadowView(color: .white,
                                          corner: (Device.screenHeight * 0.06) / 2,
                                          shadowColor: UIColor(red: 0x58/255.0,
                                                               green: 0x8F/255.0,
                                                               blue: 0x11/255.0,
                                                               alpha: 1.0).cgColor)
    let setIntroTextField = CommonTextField()
    var remainCountLabel = RegularLabel(text: "0/20",
                                        color: .myAppLightGray2)
    let setButton = CommonButton(title: .set,
                                 corner: 24,
                                 backgroundColor: .myAppMain,
                                 textColor: .white)
    
    override func configureHierarchy() {
        [backButton, titleLabel,
         profileShadowView, profileSetButton,
         setNicknameLabel, setNicknameView,
         setNicknameTextField,
         setIntroLabel, setIntroView,
         setIntroTextField, remainCountLabel,
         setButton].forEach { addSubview($0) }
        [profileMyImage].forEach { profileShadowView.addSubview($0) }
    }
    
    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
        }
        
        profileShadowView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(Device.screenHeight * 0.20)
        }
        
        profileMyImage.snp.makeConstraints { make in
            make.edges.equalTo(profileShadowView)
        }
        
        profileSetButton.snp.makeConstraints { make in
            make.top.equalTo(profileShadowView.snp.bottom).offset(16)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        setNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileSetButton.snp.bottom).offset(28)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }

        setNicknameView.snp.makeConstraints { make in
            make.top.equalTo(setNicknameLabel.snp.bottom).offset(8)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(Device.screenHeight * 0.06)
            make.width.equalTo(Device.screenWidth * 0.5)
        }

        setNicknameTextField.snp.makeConstraints { make in
            make.edges.equalTo(setNicknameView)
        }
        
        setIntroLabel.snp.makeConstraints { make in
            make.top.equalTo(setNicknameView.snp.bottom).offset(24)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }

        setIntroView.snp.makeConstraints { make in
            make.top.equalTo(setIntroLabel.snp.bottom).offset(12)
            make.height.equalTo(Device.screenHeight * 0.06)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }

        setIntroTextField.snp.makeConstraints { make in
            make.edges.equalTo(setIntroView)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.top.equalTo(setIntroView.snp.bottom).offset(8)
            make.trailing.equalTo(setIntroView)
        }

        setButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func configureView() {
        setNicknameTextField.textAlignment = .center
        setIntroTextField.textAlignment = .center
    }
}

extension ProfileSettingView {
    func updateImage(_ image: UIImage) {
        profileMyImage.image = image
    }
}
