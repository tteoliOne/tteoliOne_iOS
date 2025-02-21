//
//  ProductListTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit
import SnapKit
import RxSwift

final class ProductListTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    private let containerView = ShadowView()
    private let productImageView: LoadImageView = {
        let imageView = LoadImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "양파 100개 공유합니다~!!"
        label.textColor = .myAppBlack
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = Font.bold18
        return label
    }()
    private let markImageView = MappinImageView()
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "35m 도보 5분"
        label.textColor = .myAppLightGray2
        label.font = Font.regular13
        return label
    }()
    private let unitPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "개당 4,000원"
        label.textColor = .myAppRed
        label.font = Font.regular15
        label.textAlignment = .center
        return label
    }()
    let likeButton = LikeButton(color: .myAppLikeButton)
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .myAppBlack
        label.font = Font.regular13
        return label
    }()
    private let completedView: UIView = {
        let view = UIView()
        view.backgroundColor = .myAppMain.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        view.isHidden = true
        return view
    }()
    private let completedLabel = AndongLabel(text: "공유 완료",
                                             font: Font.Andong25,
                                             color: .white)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [containerView].forEach { contentView.addSubview($0) }
        [productImageView, titleLabel,
         markImageView, distanceLabel,
         unitPriceLabel, likeButton,
         likeCountLabel, completedView].forEach { containerView.addSubview($0) }
        [completedLabel].forEach { completedView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        productImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(containerView)
            make.width.equalTo(containerView.snp.width).multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(20)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.trailing.equalTo(containerView).inset(12)
        }
        
        markImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(containerView).inset(20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(markImageView)
            make.leading.equalTo(markImageView.snp.trailing).offset(4)
        }
        
        unitPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).inset(12)
            make.bottom.equalTo(containerView).inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.trailing.equalTo(containerView).inset(12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(likeButton)
            make.top.equalTo(likeButton.snp.bottom).offset(4)
        }
        
        completedView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.center.equalTo(completedView)
        }
    }
    
    private func updateLikeButton(isLiked: Bool, likeCount: Int) {
        likeButton.updateLikeState(isLiked: isLiked)
        likeCountLabel.text = "\(likeCount)"
    }
}

extension ProductListTableViewCell {
    func configure(with data: ProductPreviewDTO) {
        if let imageUrl = URL(string: data.imageUrl) {
            productImageView.loadImage(from: imageUrl)
        } else {
            productImageView.image = nil
        }
        titleLabel.text = data.title
        distanceLabel.text = String(format: "%.fkm 도보 \(data.walkingTime)분",
                                    data.walkingDistance / 1000)
        unitPriceLabel.text = "개당 \(FormatterManager.shared.numberFormatter(data.unitPrice))원"
        likeCountLabel.text = "\(data.totalLikes)"
        likeButton.updateLikeState(isLiked: data.liked)
        likeButton.isSelected = data.liked
        if data.soldStatus == "eSoldOut" {
            completedView.isHidden = false
        } else {
            completedView.isHidden = true
        }
    }
}
