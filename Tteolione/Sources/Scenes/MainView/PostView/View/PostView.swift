//
//  PostView.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import SnapKit

final class PostView: BaseView, UITextViewDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    //MARK: - 상품사진등록
    private let productImageLabel = AndongLabel(text: AppText.PostProduct.photoImage,
                                                color: .myAppBlack)
    private let photoScrollView = UIScrollView()
    let productPhotoButton = SymbolImageButton(name: "camera")
    
    //MARK: - 제목
    private let titleView = ShadowView()
    private let titleLabel = AndongLabel(text: AppText.PostProduct.title,
                                         color: .myAppMain)
    let titleTextField = LineTextField(text: .productTitle,
                                       keboard: .default,
                                       isSecure: nil)
    private let titleTextFieldBoundarLineView = BoundarView(.myAppBlack)
    let titleSpaceWarningLabel = RegularLabel(text: AppText.PostProduct.titleWarning,
                                              color: .myAppRed)
    let titleWordCountLabel = RegularLabel(text: AppText.PostProduct.titleWordCount,
                                           color: .myAppLightGray2)
    
    //MARK: - 구입
    private let purchaseView = ShadowView()
    private let purchasePriceLabel = AndongLabel(text: AppText.PostProduct.buyPrice,
                                         color: .myAppMain)
    private let purchaseCountLabel = AndongLabel(text: AppText.PostProduct.buyCount,
                                         color: .myAppMain)
    private let purchaseSlashLabel = SlashLabel(font: Font.regular28)
    private let purchaseWonLabel = RegularLabel(text: AppText.PostProduct.won,
                                                color: .myAppBlack)
    private let purchasePCSLabel = RegularLabel(text: AppText.PostProduct.count,
                                                color: .myAppBlack)
    let purchasePriceTextField = LineTextField(text: .noting,
                                       keboard: .default,
                                       isSecure: nil)
    let purchaseCountTextField = LineTextField(text: .noting,
                                       keboard: .default,
                                       isSecure: nil)
    private let purchasePriceTextFieldBoundarLineView = BoundarView(.myAppBlack)
    private let purchaseCountTextFieldBoundarLineView = BoundarView(.myAppBlack)
    let purchaseSpaceWarningLabel = RegularLabel(text: AppText.PostProduct.spaceWarning,
                                              color: .myAppRed)
    
    //MARK: - 공유
    private let shareView = ShadowView()
    private let sharePriceLabel = AndongLabel(text: AppText.PostProduct.sharePrice,
                                         color: .myAppMain)
    private let shareCountLabel = AndongLabel(text: AppText.PostProduct.sharePrice,
                                         color: .myAppMain)
    private let shareSlashLabel = SlashLabel(font: Font.regular28)
    private let shareWonLabel = RegularLabel(text: AppText.PostProduct.won,
                                                color: .myAppBlack)
    private let sharePCSLabel = RegularLabel(text: AppText.PostProduct.count,
                                                color: .myAppBlack)
    let sharePriceTextField = LineTextField(text: .noting,
                                       keboard: .default,
                                       isSecure: nil)
    let shareCountTextField = LineTextField(text: .noting,
                                       keboard: .default,
                                       isSecure: nil)
    private let sharePriceTextFieldBoundarLineView = BoundarView(.myAppBlack)
    private let shareCountTextFieldBoundarLineView = BoundarView(.myAppBlack)
    let shareSpaceWarningLabel = RegularLabel(text: AppText.PostProduct.spaceWarning,
                                              color: .myAppRed)
    
    //MARK: - 구매일자
    private let dateView = ShadowView()
    private let dateLabel = AndongLabel(text: AppText.PostProduct.buyDay,
                                       color: .myAppMain)
    private let datePick: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.date = Date()
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: true)
        
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        
        datePicker.tintColor = UIColor(red: 0x58/255.0, green: 0x8F/255.0, blue: 0x11/255.0, alpha: 1.0)
        
        datePicker.backgroundColor = .white
        datePicker.layer.shadowColor = UIColor.black.cgColor
        datePicker.layer.masksToBounds = false
        datePicker.layer.shadowOffset = CGSize(width: 0, height: 4)
        datePicker.layer.shadowRadius = 5
        datePicker.layer.shadowOpacity = 0.3
        
        return datePicker
    }()
    
    //MARK: - 카테고리
    private let categoryView = ShadowView()
    private let categoryLabel = AndongLabel(text: AppText.PostProduct.category,
                                       color: .myAppMain)
    private let vegetableButton = CommonButton(title: .vegetable,
                                               corner: 20,
                                               backgroundColor: .myAppLightGray,
                                               textColor: .myAppBlack,
                                               font: Font.regular16)
    private let fruitButton = CommonButton(title: .fruit,
                                           corner: 20,
                                           backgroundColor: .myAppLightGray,
                                           textColor: .myAppBlack,
                                           font: Font.regular16)
    private let mealKitButton = CommonButton(title: .mealKit,
                                             corner: 20,
                                             backgroundColor: .myAppLightGray,
                                             textColor: .myAppBlack,
                                             font: Font.regular16)
    private let meatButton = CommonButton(title: .meat,
                                          corner: 20,
                                          backgroundColor: .myAppLightGray,
                                          textColor: .myAppBlack,
                                          font: Font.regular16)
    private let seaFoodButton = CommonButton(title: .seaFood,
                                             corner: 20,
                                             backgroundColor: .myAppLightGray,
                                             textColor: .myAppBlack,
                                             font: Font.regular16)
    private let etcButton = CommonButton(title: .etc,
                                         corner: 20,
                                         backgroundColor: .myAppLightGray,
                                         textColor: .myAppBlack,
                                         font: Font.regular16)
    
    //MARK: - 상세설명
    private let descriptionView = ShadowView()
    private let descriptionLabel = AndongLabel(text: AppText.PostProduct.detailExplain,
                                          color: .myAppMain)
    private let textViewPlaceHolder = AppText.PostProduct.detailPlaceholder
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.font = Font.regular15
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.myAppDarkGray.cgColor
        view.tintColor = .black
        view.textAlignment = .left
        view.isScrollEnabled = true
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.delegate = self
        return view
    }()
    private var remainCountLabel = RegularLabel(text: AppText.PostProduct.detailWordCount, color: .myAppLightGray2)
    
    //MARK: - 희망공유장소
    private let placeView = ShadowView()
    private let placeLabel = AndongLabel(text: AppText.PostProduct.sharePlace,
                                          color: .myAppMain)
    private let placeButton = CommonButton(title: .selectPlace,
                                           corner: 10,
                                           backgroundColor: .myAppLightGray2,
                                           textColor: .myAppBlack,
                                           font: Font.regular15)
    //MARK: - 다음버튼
    let nextButton = CommonButton(title: .next,
                                          corner: 24,
                                          backgroundColor: .myAppMain,
                                          textColor: .white)
    
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [productImageLabel, photoScrollView,
         titleView, purchaseView,
         shareView, dateView,
         categoryView, descriptionView,
         placeView, nextButton].forEach { contentView.addSubview($0) }
        photoScrollView.addSubview(productPhotoButton)
        [titleLabel, titleTextField,
         titleTextFieldBoundarLineView,
         titleSpaceWarningLabel,
         titleWordCountLabel].forEach { titleView.addSubview($0) }
        [purchasePriceLabel, purchaseCountLabel,
         purchaseSlashLabel, purchasePriceTextField,
         purchaseCountTextField, purchaseWonLabel,
         purchasePCSLabel,
         purchasePriceTextFieldBoundarLineView,
         purchaseCountTextFieldBoundarLineView,
         purchaseSpaceWarningLabel].forEach { purchaseView.addSubview($0) }
        [sharePriceLabel,shareCountLabel,
         shareSlashLabel, sharePriceTextField,
         shareCountTextField, shareWonLabel,
         sharePCSLabel,
         sharePriceTextFieldBoundarLineView,
         shareCountTextFieldBoundarLineView,
         shareSpaceWarningLabel].forEach { shareView.addSubview($0) }
        [dateLabel, datePick].forEach { dateView.addSubview($0) }
        [categoryLabel, vegetableButton,
         fruitButton, mealKitButton,
         meatButton, seaFoodButton,
         etcButton].forEach { categoryView.addSubview($0) }
        [descriptionLabel, descriptionTextView,
         remainCountLabel].forEach { descriptionView.addSubview($0) }
        [placeLabel, placeButton].forEach { placeView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        productImageLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(28)
            make.top.equalTo(contentView).inset(20)
        }
        
        photoScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.top.equalTo(productImageLabel.snp.bottom).offset(20)
            make.height.equalTo((Device.screenWidth)/4)
        }
        
        productPhotoButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoScrollView)
            make.leading.equalTo(photoScrollView).inset(8)
            make.height.equalTo((Device.screenWidth - 80)/4)
            make.width.equalTo((Device.screenWidth - 86)/4)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(photoScrollView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(112)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView).inset(12)
            make.leading.equalTo(titleView).inset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleView).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(32)
        }
        
        titleTextFieldBoundarLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        titleSpaceWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldBoundarLineView.snp.bottom).offset(4)
            make.leading.equalTo(titleTextFieldBoundarLineView)
        }
        
        titleWordCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(titleTextFieldBoundarLineView)
            make.top.equalTo(titleTextFieldBoundarLineView.snp.bottom).offset(4)
        }
        
        purchaseView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(108)
        }
        
        purchasePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(purchaseView).inset(12)
            make.centerX.equalTo(purchaseView.snp.leading).inset((Device.screenWidth - 56) / 4)
        }

        purchaseCountLabel.snp.makeConstraints { make in
            make.top.equalTo(purchaseView).inset(12)
            make.centerX.equalTo(purchaseView.snp.leading).inset((Device.screenWidth - 56) * 3 / 4)
        }
        
        purchaseSlashLabel.snp.makeConstraints { make in
            make.top.equalTo(purchasePriceLabel.snp.bottom).offset(8)
            make.centerX.equalTo(purchaseView)
        }
        
        purchasePriceTextField.snp.makeConstraints { make in
            make.top.equalTo(purchasePriceLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(((Device.screenWidth - 56) / 2) - 60)
            make.leading.equalTo(purchaseView).inset(20)
        }
        
        purchaseWonLabel.snp.makeConstraints { make in
            make.leading.equalTo(purchasePriceTextField.snp.trailing).offset(8)
            make.bottom.equalTo(purchasePriceTextField)
        }
        
        purchasePriceTextFieldBoundarLineView.snp.makeConstraints { make in
            make.leading.equalTo(purchasePriceTextField)
            make.trailing.equalTo(purchaseWonLabel)
            make.height.equalTo(1)
            make.top.equalTo(purchasePriceTextField.snp.bottom).offset(2)
        }
        
        purchaseCountTextField.snp.makeConstraints { make in
            make.top.equalTo(purchaseCountLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(((Device.screenWidth - 56) / 2) - 60)
            make.leading.equalTo(purchaseSlashLabel).inset(20)
        }
        
        purchasePCSLabel.snp.makeConstraints { make in
            make.leading.equalTo(purchaseCountTextField.snp.trailing).offset(8)
            make.bottom.equalTo(purchaseCountTextField)
        }
        
        purchaseCountTextFieldBoundarLineView.snp.makeConstraints { make in
            make.leading.equalTo(purchaseCountTextField)
            make.trailing.equalTo(purchasePCSLabel)
            make.height.equalTo(1)
            make.top.equalTo(purchaseCountTextField.snp.bottom).offset(2)
        }
        
        purchaseSpaceWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(purchasePriceTextFieldBoundarLineView)
            make.top.equalTo(purchasePriceTextFieldBoundarLineView.snp.bottom).offset(4)
        }
        
        shareView.snp.makeConstraints { make in
            make.top.equalTo(purchaseView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(108)
        }
        
        sharePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(shareView).inset(12)
            make.centerX.equalTo(shareView.snp.leading).inset((Device.screenWidth - 56) / 4)
        }

        shareCountLabel.snp.makeConstraints { make in
            make.top.equalTo(shareView).inset(12)
            make.centerX.equalTo(shareView.snp.leading).inset((Device.screenWidth - 56) * 3 / 4)
        }
        
        shareSlashLabel.snp.makeConstraints { make in
            make.top.equalTo(sharePriceLabel.snp.bottom).offset(8)
            make.centerX.equalTo(shareView)
        }
        
        sharePriceTextField.snp.makeConstraints { make in
            make.top.equalTo(sharePriceLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(((Device.screenWidth - 56) / 2) - 60)
            make.leading.equalTo(shareView).inset(20)
        }
        
        shareWonLabel.snp.makeConstraints { make in
            make.leading.equalTo(sharePriceTextField.snp.trailing).offset(8)
            make.bottom.equalTo(sharePriceTextField)
        }
        
        sharePriceTextFieldBoundarLineView.snp.makeConstraints { make in
            make.leading.equalTo(sharePriceTextField)
            make.trailing.equalTo(shareWonLabel)
            make.height.equalTo(1)
            make.top.equalTo(sharePriceTextField.snp.bottom).offset(2)
        }
        
        shareCountTextField.snp.makeConstraints { make in
            make.top.equalTo(shareCountLabel.snp.bottom).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(((Device.screenWidth - 56) / 2) - 60)
            make.leading.equalTo(shareSlashLabel).inset(20)
        }
        
        sharePCSLabel.snp.makeConstraints { make in
            make.leading.equalTo(shareCountTextField.snp.trailing).offset(8)
            make.bottom.equalTo(shareCountTextField)
        }
        
        shareCountTextFieldBoundarLineView.snp.makeConstraints { make in
            make.leading.equalTo(shareCountTextField)
            make.trailing.equalTo(sharePCSLabel)
            make.height.equalTo(1)
            make.top.equalTo(shareCountTextField.snp.bottom).offset(2)
        }
        
        shareSpaceWarningLabel.snp.makeConstraints { make in
            make.leading.equalTo(sharePriceTextFieldBoundarLineView)
            make.top.equalTo(sharePriceTextFieldBoundarLineView.snp.bottom).offset(4)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(shareView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(160)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateView).inset(12)
            make.leading.equalTo(dateView).inset(20)
        }
        
        datePick.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(dateView).inset(20)
            make.height.equalTo(96)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(160)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryView).inset(12)
            make.leading.equalTo(categoryView).inset(20)
        }
        
        vegetableButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView.snp.leading).inset((Device.screenWidth - 56) / 5)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        fruitButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        mealKitButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView.snp.leading).inset((Device.screenWidth - 56)*4 / 5)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        meatButton.snp.makeConstraints { make in
            make.top.equalTo(vegetableButton.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView.snp.leading).inset((Device.screenWidth - 56) / 5)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        seaFoodButton.snp.makeConstraints { make in
            make.top.equalTo(vegetableButton.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        etcButton.snp.makeConstraints { make in
            make.top.equalTo(vegetableButton.snp.bottom).offset(12)
            make.centerX.equalTo(categoryView.snp.leading).inset((Device.screenWidth - 56)*4 / 5)
            make.width.equalTo((Device.screenWidth - 160) / 3)
            make.height.equalTo(40)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(300)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionView).inset(12)
            make.leading.equalTo(descriptionView).inset(20)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(descriptionView).inset(20)
            make.bottom.equalTo(descriptionView).inset(40)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(descriptionTextView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(4)
        }
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(300)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView).inset(12)
            make.leading.equalTo(placeView).inset(20)
        }
        
        placeButton.snp.makeConstraints { make in
            make.top.equalTo(placeView).inset(12)
            make.trailing.equalTo(placeView).inset(20)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView).inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
    }
    
    override func configureView() {
        
    }
    
}
