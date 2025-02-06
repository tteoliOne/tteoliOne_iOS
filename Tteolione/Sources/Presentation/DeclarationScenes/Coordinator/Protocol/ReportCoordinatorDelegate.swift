//
//  ReportCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import Foundation

protocol ReportCoordinatorDelegate: Coordinator {
    func pushReportViewController()
    func pushEtcReportViewController()
    func finishView()
}
