//
//  MainTableViewCell.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainTableViewCell: BaseTableViewCell {
    
    var disposeBag = DisposeBag()
    let likeButtonTapped = PublishRelay<Int>()
    
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
    
    func configure(productList: ProductListDTO) {
        categoryLabel.text = productList.categoryName
        
        let displayProducts = productList.products.prefix(5).map { ProductListItem.product($0) }
        let items: [ProductListItem] = displayProducts + [.nextButton]
        
        Observable.just(items)
            .bind(to: collectionView.rx.items) { collectionView, index, item in
                switch item {
                case .product(let product):
                    if let productCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProductCollectionViewCell.identifier,
                        for: IndexPath(item: index, section: 0)
                    ) as? ProductCollectionViewCell {
                        productCell.product = product
                        productCell.likeButtonTapped
                            .subscribe(onNext: { [weak self] productId in
                                guard let self = self else { return }
                                self.likeButtonTapped.accept(productId)
                            })
                            .disposed(by: productCell.disposeBag)
                        return productCell
                    }
                    
                case .nextButton:
                    if let buttonCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: NextButtonCollectionViewCell.identifier,
                        for: IndexPath(item: index, section: 0)
                    ) as? NextButtonCollectionViewCell {
                        buttonCell.configureButton()
                        return buttonCell
                    }
                }
                return UICollectionViewCell()
            }
            .disposed(by: disposeBag)
    }
    
}
