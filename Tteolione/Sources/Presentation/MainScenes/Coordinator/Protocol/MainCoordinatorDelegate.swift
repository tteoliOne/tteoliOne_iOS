//
//  MainCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import UIKit

protocol MainCoordinatorDelegate: Coordinator {
    func pushPostViewController()
    func pushProductDetailViewController(productId: Int)
    func pushMapViewController()
    func pushPostReceiptViewController(with productRequestBody: ProductRequestBody,
                                       productImages: [UIImage])
    func dismissAndPop()
}
