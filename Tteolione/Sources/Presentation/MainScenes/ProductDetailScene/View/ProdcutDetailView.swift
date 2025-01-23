//
//  ProdcutDetailView.swift
//  Tteolione
//
//  Created by 전준영 on 1/11/25.
//

import UIKit
import SnapKit

final class ProductDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let productImagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    private let productFieldView = UIView()
    private let profileImageView = CircleImageView(joinImage: .setProfile,
                                                   corner: 30,
                                                   border: 1)
    private let nicknameLabel = RegularLabel(text: "닉네임",
                                             color: .myAppBlack)
    private let titleLabel = BoldLabel(text: "제목",
                                       font: Font.bold20,
                                       color: .myAppBlack)
    private let boundarView = BoundarView(.myAppBlack)
    private let buyDateExplainLabel = AndongLabel(text: AppText.PostProduct.buyDay,
                                                  color: .myAppMain)
    private let buyDateLabel = RegularLabel(text: "0000.00.00(화)",
                                            font: Font.regular13,
                                            color: .myAppBlack)
    private let likeButton = LikeButton(color: .myAppMain)
    private let likeCountLabel = RegularLabel(text: "0",
                                              font: Font.regular13,
                                              color: .myAppBlack)
    private let receiptButton: UIButton = {
        let button = UIButton()
        let newSize = CGSize(width: 24, height: 24)
        if let receiptImage = UIImage(named: "receiptPhoto")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch) {
            let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                receiptImage.draw(in: CGRect(origin: .zero, size: newSize))
            }
            button.setBackgroundImage(resizedImage, for: .normal)
        }
        return button
    }()
    private let receiptLabel = RegularLabel(text: AppText.Etc.recipet,
                                            font: Font.regular13,
                                            color: .myAppBlack)
    
    private let buyPriceFieldView = ShadowView(color: .myAppMain,
                                               corner: 28)
    private let buyPriceImageView = CircleImageView(joinImage: .buyPrice,
                                                    corner: 20,
                                                    border: 0)
    private let buyPriceLabel = BoldLabel(text: AppText.PostProduct.buyPrice,
                                          color: .white)
    private let buyPriceWonLabel = RegularLabel(text: AppText.PostProduct.won,
                                                font: Font.regular15,
                                                color: .white)
    
    private let buyCountFieldView = ShadowView(color: .myAppMain,
                                               corner: 28)
    private let buyCountImageView = CircleImageView(joinImage: .buyCount,
                                                    corner: 15,
                                                    border: 0)
    private let buyCountLabel = BoldLabel(text: AppText.PostProduct.buyCount,
                                          color: .white)
    private let buyCountPCSLabel = RegularLabel(text: AppText.PostProduct.count,
                                                font: Font.regular15,
                                                color: .white)
    
    private let sharePriceFieldView = ShadowView(color: .myAppMain,
                                                 corner: 28)
    private let sharePriceImageView = CircleImageView(joinImage: .sharePrice,
                                                      corner: 15,
                                                      border: 0)
    private let sharePriceLabel = BoldLabel(text: AppText.PostProduct.sharePrice,
                                            color: .white)
    private let sharePriceWonLabel = RegularLabel(text: AppText.PostProduct.won,
                                                  font: Font.regular15,
                                                  color: .white)
    
    private let shareCountFieldView = ShadowView(color: .myAppMain,
                                                 corner: 28)
    private let shareCountImageView = CircleImageView(joinImage: .shareCount,
                                                      corner: 15,
                                                      border: 0)
    private let shareCountLabel = BoldLabel(text: AppText.PostProduct.shareCount,
                                            color: .white)
    private let shareCountPCSLabel = RegularLabel(text: AppText.PostProduct.count,
                                                  font: Font.regular15,
                                                  color: .white)
    
    private let detailView = ShadowView()
    private let detailLabel = AndongLabel(text: AppText.PostProduct.detailExplain,
                                          color: .myAppMain)
    private let contentLabel = RegularLabel(text: "상세 내용입니다",
                                            font: Font.regular17,
                                            color: .myAppBlack)
    private let placeView = ShadowView()
    private let placeLabel = AndongLabel(text: AppText.PostProduct.sharePlace,
                                         color: .myAppMain)
    private let callButton = CommonButton(title: .call,
                                          corner: 20,
                                          backgroundColor: .myAppMain,
                                          textColor: .white)
    
    override func configureHierarchy() {
        [scrollView, callButton].forEach { addSubview($0) }
        [contentView].forEach { scrollView.addSubview($0) }
        [productImagesScrollView, productFieldView,
         imagePageControl].forEach { contentView.addSubview($0) }
        [profileImageView, nicknameLabel,
         titleLabel, boundarView,
         buyDateExplainLabel, buyDateLabel,
         likeButton, likeCountLabel,
         receiptButton, receiptLabel,
         buyPriceFieldView, buyCountFieldView,
         sharePriceFieldView, shareCountFieldView,
         detailView, placeView].forEach { productFieldView.addSubview($0) }
        [buyPriceImageView, buyPriceLabel,
         buyPriceWonLabel].forEach { buyPriceFieldView.addSubview($0) }
        [buyCountImageView, buyCountLabel,
         buyCountPCSLabel].forEach { buyCountFieldView.addSubview($0) }
        [sharePriceImageView, sharePriceLabel,
         sharePriceWonLabel].forEach { sharePriceFieldView.addSubview($0) }
        [shareCountImageView, shareCountLabel,
         shareCountPCSLabel].forEach { shareCountFieldView.addSubview($0) }
        [detailLabel, contentLabel].forEach { detailView.addSubview($0) }
        [placeLabel].forEach { placeView.addSubview($0) }
        
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        productImagesScrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(260)
        }
        
        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(productImagesScrollView).inset(8)
            make.height.equalTo(20)
        }
        
        productFieldView.snp.makeConstraints { make in
            make.top.equalTo(productImagesScrollView.snp.bottom).offset(-12)
            make.width.equalTo(contentView.snp.width)
            make.bottom.equalTo(contentView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalTo(productFieldView).inset(24)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalTo(profileImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
        }
        
        boundarView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(productFieldView)
            make.height.equalTo(1)
        }
        
        buyDateExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(boundarView.snp.bottom).offset(16)
            make.centerX.equalTo((Device.screenWidth)/5)
        }
        
        buyDateLabel.snp.makeConstraints { make in
            make.top.equalTo(buyDateExplainLabel.snp.bottom).offset(8)
            make.centerX.equalTo(buyDateExplainLabel)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(boundarView.snp.bottom).offset(16)
            make.centerX.equalTo(productFieldView)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(4)
            make.centerX.equalTo(likeButton)
        }
        
        receiptButton.snp.makeConstraints { make in
            make.top.equalTo(boundarView.snp.bottom).offset(16)
            make.centerX.equalTo((Device.screenWidth)*4/5)
        }
        
        receiptLabel.snp.makeConstraints { make in
            make.top.equalTo(receiptButton.snp.bottom).offset(4)
            make.centerX.equalTo(receiptButton)
        }
        
        buyPriceFieldView.snp.makeConstraints { make in
            make.top.equalTo(buyDateLabel.snp.bottom).offset(16)
            make.leading.equalTo(productFieldView).inset(20)
            make.trailing.equalTo(productFieldView.snp.centerX).offset(-16)
            make.height.equalTo(72)
        }
        
        buyPriceImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(buyPriceFieldView).inset(20)
            make.centerY.equalTo(buyPriceFieldView)
        }
        
        buyPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(buyPriceImageView)
            make.leading.equalTo(buyPriceImageView.snp.trailing).offset(8)
        }
        
        buyPriceWonLabel.snp.makeConstraints { make in
            make.top.equalTo(buyPriceLabel.snp.bottom).offset(4)
            make.centerX.equalTo(buyPriceLabel)
        }
        
        buyCountFieldView.snp.makeConstraints { make in
            make.top.equalTo(buyDateLabel.snp.bottom).offset(16)
            make.leading.equalTo(productFieldView.snp.centerX).offset(16)
            make.trailing.equalTo(productFieldView).inset(20)
            make.height.equalTo(72)
        }
        
        buyCountImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(buyCountFieldView).inset(20)
            make.centerY.equalTo(buyCountFieldView)
        }
        
        buyCountLabel.snp.makeConstraints { make in
            make.top.equalTo(buyCountImageView)
            make.leading.equalTo(buyCountImageView.snp.trailing).offset(8)
        }
        
        buyCountPCSLabel.snp.makeConstraints { make in
            make.top.equalTo(buyCountLabel.snp.bottom).offset(4)
            make.centerX.equalTo(buyCountLabel)
        }
        
        sharePriceFieldView.snp.makeConstraints { make in
            make.top.equalTo(buyCountFieldView.snp.bottom).offset(12)
            make.leading.equalTo(productFieldView).inset(20)
            make.trailing.equalTo(productFieldView.snp.centerX).offset(-16)
            make.height.equalTo(72)
        }
        
        sharePriceImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(sharePriceFieldView).inset(20)
            make.centerY.equalTo(sharePriceFieldView)
        }
        
        sharePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(sharePriceImageView)
            make.leading.equalTo(sharePriceImageView.snp.trailing).offset(8)
        }
        
        sharePriceWonLabel.snp.makeConstraints { make in
            make.top.equalTo(sharePriceLabel.snp.bottom).offset(4)
            make.centerX.equalTo(sharePriceLabel)
        }
        
        shareCountFieldView.snp.makeConstraints { make in
            make.top.equalTo(buyCountFieldView.snp.bottom).offset(12)
            make.leading.equalTo(productFieldView.snp.centerX).offset(16)
            make.trailing.equalTo(productFieldView).inset(20)
            make.height.equalTo(72)
        }
        
        shareCountImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(shareCountFieldView).inset(20)
            make.centerY.equalTo(shareCountFieldView)
        }
        
        shareCountLabel.snp.makeConstraints { make in
            make.top.equalTo(shareCountImageView)
            make.leading.equalTo(shareCountImageView.snp.trailing).offset(8)
        }
        
        shareCountPCSLabel.snp.makeConstraints { make in
            make.top.equalTo(shareCountLabel.snp.bottom).offset(4)
            make.centerX.equalTo(shareCountLabel)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(sharePriceFieldView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(productFieldView).inset(20)
            make.height.equalTo(200)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(detailView).inset(16)
            make.leading.equalTo(detailView).inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(detailView).inset(20)
        }
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(productFieldView).inset(20)
            make.height.equalTo(200)
            make.bottom.equalTo(productFieldView).offset(-88)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView).inset(16)
            make.leading.equalTo(placeView).inset(20)
        }
        
        callButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    override func configureView() {
        productImagesScrollView.delegate = self
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        
        buyPriceImageView.backgroundColor = .white
        buyCountImageView.backgroundColor = .white
        sharePriceImageView.backgroundColor = .white
        shareCountImageView.backgroundColor = .white
    }
    
}

extension ProductDetailView {
    
    func updateUI(with productDetail: ProductDetailDTO) {
        updateScrollView(with: productDetail.images)
        if let imageUrl = URL(string: productDetail.sellerProfile) {
            profileImageView.loadImage(from: imageUrl)
        } else {
            profileImageView.image = nil
        }
        nicknameLabel.text = productDetail.sellerNickname
        titleLabel.text = productDetail.title
        buyDateLabel.text = FormatterManager.shared.formattedDate(from: productDetail.buyDate)
        thumbUpSet(productDetail.checkLiked)
        likeCountLabel.text = "\(productDetail.likeCount)"
//        receiptButton.setImage(url: productDetail.receipt)
        buyPriceWonLabel.text = "\(FormatterManager.shared.numberFormatter(productDetail.buyPrice))원"
        buyCountPCSLabel.text = "\(FormatterManager.shared.numberFormatter(productDetail.buyCount))개"
        sharePriceWonLabel.text = "\(FormatterManager.shared.numberFormatter(productDetail.sharePrice))원"
        shareCountPCSLabel.text = "\(FormatterManager.shared.numberFormatter(productDetail.shareCount))개"
        contentLabel.text = productDetail.description
    }
    
}

extension ProductDetailView {
    
    func updateScrollView(with imageUrls: [String]) {
        productImagesScrollView.subviews.forEach { $0.removeFromSuperview() }
        var previousImageView: UIView?
        imagePageControl.numberOfPages = imageUrls.count
        imagePageControl.currentPage = 0

        for urlString in imageUrls {
            guard let url = URL(string: urlString) else { continue }
            let imageView = LoadImageView()
            productImagesScrollView.addSubview(imageView)
            imageView.loadImage(from: url)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(Device.screenWidth)
                make.height.equalTo(260)
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
            }

            previousImageView = imageView
        }

        previousImageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
    }
    
    private func thumbUpSet(_ isLike: Bool) {
        let likeName = isLike ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: likeName), for: .normal)
    }
    
}

extension ProductDetailView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        imagePageControl.currentPage = currentPage
    }
    
}
