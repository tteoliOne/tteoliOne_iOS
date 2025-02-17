//
//  MainCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import UIKit

protocol MainCoordinatorDelegate: Coordinator {
    func pushPostViewController(viewType: PostViewType, productDetail: ProductDetailDTO?)
    func pushProductDetailViewController(productId: Int)
    func pushMapViewController()
    func pushPostReceiptViewController(with viewType: PostViewType,
                                       productRequestBody: ProductRequestBody,
                                       productImages: [UIImage],
                                       receiptImage: UIImage?,
                                       productId: Int?)
    func showReportView(reportType: ReportType, reportId: Int)
    func showChatView(chatId: Int, productId: Int)
    func showOpponentView(userId: Int)
    func dismissAndPop()
}
