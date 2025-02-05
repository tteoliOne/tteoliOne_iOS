//
//  SideMenuTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SideMenuTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let productImageView: LoadImageView = {
        let imageView = LoadImageView()
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    private let titleLabel = AndongLabel(text: "",
                                         font: Font.Andong15,
                                         color: .myAppBlack)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [productImageView, titleLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(productImageView.snp.bottom).offset(8)
        }
    }
    
    override func configureView() {
        backgroundColor = .myAppSideMenu
    }
    
}

extension SideMenuTableViewCell {
    func configureData(_ product: SavedProductDetailDTO) {
        titleLabel.text = product.title
        if let imageUrl = URL(string: product.productImage) {
            productImageView.loadImage(from: imageUrl)
        } else {
            productImageView.image = nil
        }
    }
}
