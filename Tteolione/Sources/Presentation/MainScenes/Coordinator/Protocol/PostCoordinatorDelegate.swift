//
//  PostCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import UIKit

protocol PostCoordinatorDelegate: Coordinator {
    func pushMapViewController()
    func pushPostReceiptViewController(with viewType: PostViewType,
                                       productRequestBody: ProductRequestBody,
                                       productImages: [UIImage],
                                       receiptImage: UIImage?,
                                       productId: Int?)
    func dismissAndPop()
}
