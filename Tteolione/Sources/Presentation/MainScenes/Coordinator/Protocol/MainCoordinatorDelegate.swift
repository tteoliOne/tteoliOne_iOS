//
//  MainCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import UIKit

protocol MainCoordinatorDelegate: Coordinator {
    func pushPostViewController(viewType: PostViewType, productDetail: ProductDetailDTO?)
    func pushProductDetailView(productId: Int)
    func pushCategoryProudctViewController(categoryId: Int)
    func pushDetailViewController(productId: Int)
}
