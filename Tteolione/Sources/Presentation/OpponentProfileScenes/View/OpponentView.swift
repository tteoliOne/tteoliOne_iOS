//
//  OpponentView.swift
//  Tteolione
//
//  Created by 전준영 on 2/16/25.
//

import UIKit
import SnapKit

final class OpponentView: BaseView {
    
    private let profileFieldView = ShadowView()
    let backButton = BackButton(size: 24)
    private let titleLabel = BoldLabel(text: "님 가게",
                                       font: Font.bold20,
                                       color: .myAppMain)
    private let profileShadowView = ShadowView(color: .white,
                                               corner: (Device.screenWidth * 0.22) / 2,
                                               shadowColor: UIColor(red: 0x58/255.0,
                                                                    green: 0x8F/255.0,
                                                                    blue: 0x11/255.0,
                                                                    alpha: 1.0).cgColor)
    private let profileMyImage = CircleImageView(joinImage: .setProfile,
                                                 corner: (Device.screenWidth * 0.22) / 2,
                                                 border: 1)
    private let thumbCountView = ShadowView(color: .white,
                                               corner: (Device.screenWidth * 0.11) / 2,
                                               shadowColor: UIColor(red: 0x58/255.0,
                                                                    green: 0x8F/255.0,
                                                                    blue: 0x11/255.0,
                                                                    alpha: 1.0).cgColor)
    private let thumbLabel = AndongLabel(text: "따봉",
                                         font: Font.Andong13,
                                         color: .myAppMain)
    private let thumbCountLabel = AndongLabel(text: "0",
                                              font: Font.Andong15,
                                              color: .myAppBlack)
    private let introLabel = RegularLabel(text: "소개글이 없습니다",
                                          font: Font.regular20,
                                          color: .myAppBlack)
    let segmentControl: CustomSegmentedControl = {
        let customSegmentedControl = CustomSegmentedControl(items: ["판매 중", "판매완료", "후기"])
        customSegmentedControl.selectionChanged = { selectedIndex in
            print("선택된 인덱스: \(selectedIndex)")
        }
        return customSegmentedControl
    }()
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(OpponentCollectionViewCell.self,
                                forCellWithReuseIdentifier: OpponentCollectionViewCell.identifier)
        return collectionView
    }()
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 16
        let numberOfItemsPerRow: CGFloat = 2
        let availableWidth = Device.screenWidth - (sectionSpacing * 2) - (cellSpacing * (numberOfItemsPerRow - 1))
        let cellWidth = availableWidth / numberOfItemsPerRow
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReviewTableViewCell.self,
                           forCellReuseIdentifier: ReviewTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func configureHierarchy() {
        [profileFieldView, segmentControl,
         collectionView, tableView].forEach { addSubview($0) }
        [backButton, titleLabel,
         profileShadowView, thumbCountView,
         introLabel].forEach { profileFieldView.addSubview($0) }
        [profileMyImage].forEach { profileShadowView.addSubview($0) }
        [thumbLabel, thumbCountLabel].forEach { thumbCountView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileFieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(Device.screenHeight * 0.19)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(profileFieldView)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        profileShadowView.snp.makeConstraints { make in
            make.centerY.equalTo(profileFieldView)
            make.leading.equalTo(profileFieldView).inset(20)
            make.size.equalTo(Device.screenWidth * 0.22)
        }
        
        profileMyImage.snp.makeConstraints { make in
            make.edges.equalTo(profileShadowView)
        }
        
        thumbCountView.snp.makeConstraints { make in
            make.size.equalTo(Device.screenWidth * 0.11)
            make.bottom.equalTo(profileMyImage).offset(12)
            make.leading.equalTo(profileMyImage).offset(-8)
        }
        
        introLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileShadowView.snp.trailing).offset(20)
            make.centerY.equalTo(profileShadowView)
        }
        
        thumbLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbCountView).inset(4)
            make.centerX.equalTo(thumbCountView)
        }
        
        thumbCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(thumbCountView)
            make.top.equalTo(thumbLabel.snp.bottom).offset(4)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(profileFieldView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}

extension OpponentView {
    func updateUI(with data: OtherUserDTO) {
        if let imageUrl = URL(string: data.profile) {
            profileMyImage.loadImage(from: imageUrl)
        } else {
            profileMyImage.image = nil
        }
        titleLabel.text = "\(data.nickname)님 가게"
        thumbCountLabel.text = "\(data.ddabongScore)"
        introLabel.text = data.intro
    }
}
