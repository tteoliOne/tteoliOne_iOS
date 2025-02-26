//
//  ReviewPopView.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import UIKit
import SnapKit

final class ReviewPopView: BaseView {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    private let popupView = ShadowView(color: .white, corner: 20)
    private let titleLabel = BoldLabel(text: "공유 후기",
                                       font: Font.bold18,
                                       color: .myAppMain)
    let descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = Font.regular15
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.myAppDarkGray.cgColor
        view.tintColor = .black
        view.textAlignment = .left
        view.isScrollEnabled = true
        view.textColor = .myAppBlack
        view.layer.cornerRadius = 8
        return view
    }()
    var remainCountLabel = RegularLabel(text: AppText.PostProduct.detailWordCount,
                                        color: .myAppLightGray2)
    let chevronUpButton = UpAndDownButton(title: "chevron.up")
    let scoreLabel = RegularLabel(text: "1",
                                  font: Font.regular15,
                                  color: .myAppBlack)
    let chevronDownButton = UpAndDownButton(title: "chevron.down")
    let submitButton = CommonButton(title: .write,
                                    corner: 24,
                                    backgroundColor: .myAppLightGray2,
                                    textColor: .white)
    
    override func configureHierarchy() {
        [backgroundView, popupView].forEach { addSubview($0) }
        [titleLabel, descriptionTextView,
         remainCountLabel,scoreLabel,
         chevronUpButton, chevronDownButton,
         submitButton].forEach { popupView.addSubview($0) }
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(Device.screenHeight * 0.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(popupView).offset(16)
            make.centerX.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(Device.screenHeight * 0.2)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(4)
            make.trailing.equalTo(descriptionTextView)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionTextView.snp.bottom).offset(12)
        }
        
        chevronUpButton.snp.makeConstraints { make in
            make.leading.equalTo(scoreLabel.snp.trailing).offset(12)
            make.centerY.equalTo(scoreLabel)
            make.size.equalTo(24)
        }
        
        chevronDownButton.snp.makeConstraints { make in
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-12)
            make.centerY.equalTo(scoreLabel)
            make.size.equalTo(24)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(popupView).offset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }

}

extension ReviewPopView {
    func setButton(_ isEnabled: Bool) {
        submitButton.backgroundColor = isEnabled ? .myAppMain : .myAppLightGray2
        submitButton.isEnabled = isEnabled
    }
}
