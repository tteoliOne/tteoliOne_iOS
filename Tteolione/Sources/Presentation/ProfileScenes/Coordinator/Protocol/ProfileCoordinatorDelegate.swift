//
//  ProfileCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import Foundation

protocol ProfileCoordinatorDelegate: Coordinator {
    func pushMyProductViewController(status: StatusType)
    func pushDetailViewController(productId: Int)
    func pushMyReviewViewController()
    func showSettingView()
}
