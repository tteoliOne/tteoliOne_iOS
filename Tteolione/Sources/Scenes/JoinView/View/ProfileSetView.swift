//
//  ProfileSetView.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import SnapKit

final class ProfileSetView: BaseView {
    
    let topBarView = TopBarView()
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.joinProfile
        label.font = Font.bold20
        return label
    }()
    let profileImage = CircleImageView(joinImage: .setProfile,
                                       corner: 100,
                                       border: 2)
    let profileChangeButton = CommonButton(title: .profile,
                                           corner: 12,
                                           backgroundColor: .myAppLightGray2,
                                           textColor: .myAppBlack)
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.Join.joinProfileExplain
        label.font = Font.bold15
        label.textColor = .myAppBlack
        return label
    }()
    let joinButton = JoinButton(title: .complete)
    
    override func configureHierarchy() {
        [topBarView, profileLabel,
         profileImage, profileChangeButton,
         explanationLabel, joinButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        topBarView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(topBarView.snp.bottom).offset(60)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(200)
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
        }
        
        profileChangeButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(profileImage)
            make.height.equalTo(52)
            make.top.equalTo(profileImage.snp.bottom).offset(20)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(profileChangeButton.snp.bottom).offset(20)
        }
        
        joinButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
    }
    
    override func configureView() {
        
    }
    
}
