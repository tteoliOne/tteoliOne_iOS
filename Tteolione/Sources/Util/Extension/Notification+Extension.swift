//
//  Notification+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 1/30/25.
//

import Foundation

extension Notification.Name {
    static let recentSearchUpdated = Notification.Name("recentSearchUpdated")
    static let didReceiveMessage = Notification.Name("didReceiveMessage")
    static let didCallBackMessage = Notification.Name("didCallBackMessage")
    static let didReceiveRequestMessage = Notification.Name("didReceiveRequestMessage")
    static let didReceiveRejectMessage = Notification.Name("didReceiveRejectMessage")
    static let didReceivePendingRequest = Notification.Name("didReceivePendingRequest")
    static let didReceiveRejectApprove = Notification.Name("didReceiveRejectApprove")
    static let didReceiveApprove = Notification.Name("didReceiveApprove")
    static let didReceiveApproveToReview = Notification.Name("didReceiveApproveToReview")
    static let didCompleteReview = Notification.Name("didCompleteReview")
    static let didLeaveChat = Notification.Name("didLeaveChat")
    static let logout = Notification.Name("Logout")
    static let nicknameDidChange = Notification.Name("nicknameDidChange")
    static let toggleLike = Notification.Name("toggleLike")
    static let didComeOpponent = Notification.Name("didComeOpponent")
    static let didBackChat = Notification.Name("didBackChat")
}
