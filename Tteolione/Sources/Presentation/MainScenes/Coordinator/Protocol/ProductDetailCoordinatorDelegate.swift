//
//  ProductDetailCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import Foundation

protocol ProductDetailCoordinatorDelegate: Coordinator {
    func pushPostViewController(viewType: PostViewType, productDetail: ProductDetailDTO?)
    func showReportView(reportType: ReportType, reportId: Int)
    func showChatView(chatId: Int, productId: Int, opponentName: String)
    func showOpponentView(userId: Int)
}
