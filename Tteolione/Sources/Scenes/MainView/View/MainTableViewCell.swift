//
//  MainTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift

final class MainTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "야채"
        label.font = Font.Andong18
        label.textColor = .myAppMain
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(ProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.register(NextButtonCollectionViewCell.self, forCellWithReuseIdentifier: NextButtonCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 250)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [categoryLabel, collectionView]
            .forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        categoryLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.leading.equalTo(categoryLabel)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(268)
        }
    }
    
    func configure(category: String, products: [Product]) {
        categoryLabel.text = category
        let productsWithButton = products + [Product(name: "NextButton", price: 0, distance: "")]
        Observable.just(productsWithButton)
            .bind(to: collectionView.rx.items) { collectionView, index, product in
                if product.name == "NextButton" {
                    let buttonCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: NextButtonCollectionViewCell.identifier,
                        for: IndexPath(item: index, section: 0)
                    ) as! NextButtonCollectionViewCell
                    buttonCell.configureButton()
                    return buttonCell
                } else {
                    let productCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProductCollectionViewCell.identifier,
                        for: IndexPath(item: index, section: 0)
                    ) as! ProductCollectionViewCell
                    productCell.configure(with: product)
                    return productCell
                }
            }
            .disposed(by: disposeBag)
    }

    
    override func configureView() {
        
    }
    
}

struct Product {
    let name: String
    let price: Int
    let distance: String
}

struct MainSectionModel {
    let category: String
    let products: [Product]
}
