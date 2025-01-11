//
//  ProductCollectionViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift

final class ProductCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    private let priceFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        return view
    }()
    private let unitPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "개당 4,000원"
        label.textColor = .myAppRed
        label.font = Font.regular15
        label.textAlignment = .center
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "양파 100개 공유합니다~!!"
        label.textColor = .myAppBlack
        label.font = Font.regular16
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
    let likeButton = LikeButton(color: .myAppLikeButton)
    private let likeCountLable: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .myAppBlack
        label.font = Font.regular13
        return label
    }()
    
    override func configureHierarchy() {
        [productImageView, priceFieldView,
         titleLabel, markImageView,
         distanceLabel, likeButton,
         likeCountLable].forEach { contentView.addSubview($0) }
        
        [unitPriceLabel].forEach { priceFieldView.addSubview($0) }
    }
    
    override func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(160)
        }
        
        priceFieldView.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView.snp.bottom)
            make.trailing.equalTo(productImageView)
            make.height.equalTo(28)
            make.width.equalTo(120)
        }
        
        unitPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceFieldView)
            make.horizontalEdges.equalTo(priceFieldView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(20)
            make.leading.equalTo(productImageView).inset(8)
            make.width.equalTo(150)
        }
        
        markImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(markImageView)
            make.leading.equalTo(markImageView.snp.trailing).offset(4)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        likeCountLable.snp.makeConstraints { make in
            make.centerX.equalTo(likeButton)
            make.top.equalTo(likeButton.snp.bottom).offset(4)
        }
    }
    
    override func configureView() {
        cellView()
        productImageView.backgroundColor = .yellow
        
    }
    
    private func cellView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
    }

    func configure(with product: Product) {
        titleLabel.text = product.name
        unitPriceLabel.text = "\(product.price)원"
        distanceLabel.text = product.distance
    }
    
}
