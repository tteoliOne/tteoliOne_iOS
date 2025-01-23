//
//  MainCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import Foundation

protocol MainCoordinatorDelegate: Coordinator {
    func pushPostViewController()
    func pushProductDetailViewController(productId: Int)
}
