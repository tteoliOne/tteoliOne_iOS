//
//  PostReceiptView.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import SnapKit

final class PostReceiptView: BaseView {
    
    private let receiptLabel = AndongLabel(text: AppText.PostProduct.recipetImage,
                                           font: Font.Andong25,
                                           color: .myAppMain)
    let photoButton = SymbolImageButton(name: "camera.on.rectangle.fill")
    private let receiptExplainLabel = RegularLabel(text: AppText.PostProduct.recipetExplain,
                                                   font: Font.regular20,
                                                   color: .myAppBlack)
    private let receiptDetailExplainLabel = RegularLabel(text: AppText.PostProduct.recipetDetailExplain,
                                                         color: .myAppBlack)
    let registerButton = CommonButton(title: .register,
                                      corner: 20,
                                      backgroundColor: .myAppMain,
                                      textColor: .white)
    private var imageView: UIImageView?
    
    override func configureHierarchy() {
        [receiptLabel, photoButton,
         receiptExplainLabel, receiptDetailExplainLabel,
         registerButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        receiptLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(28)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(receiptLabel.snp.bottom).offset(28)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo((Device.screenHeight / 2) / 3)
        }
        
        receiptExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(12)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        receiptDetailExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(receiptExplainLabel.snp.bottom).offset(8)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        receiptDetailExplainLabel.numberOfLines = 0
        setupImageView()
    }
    
}

extension PostReceiptView {
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(photoButton)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleImageViewTap))
        imageView.addGestureRecognizer(tapGesture)
        
        self.imageView = imageView
    }

    @objc private func handleImageViewTap() {
        photoButton.sendActions(for: .touchUpInside)
    }
    
    func updateImage(_ image: UIImage) {
        imageView?.image = image
    }
}
