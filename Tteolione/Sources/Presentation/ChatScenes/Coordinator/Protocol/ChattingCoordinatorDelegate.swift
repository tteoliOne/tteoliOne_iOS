//
//  ChattingCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import Foundation

protocol ChattingCoordinatorDelegate: Coordinator {
    func finishView()
    func pushReviewView(productId: Int)
    func showReportView(reportType: ReportType, reportId: Int, opponentId: Int)
}
