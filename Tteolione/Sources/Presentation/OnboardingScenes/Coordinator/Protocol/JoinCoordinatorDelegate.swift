//
//  JoinCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import Foundation

protocol JoinCoordinatorDelegate: Coordinator {
    func pushEmailAuthViewController()
    func pushAuthNumViewController()
    func pushNameViewController()
    func pushIdViewController()
    func pushPasswordViewController()
    func pushNicknameViewController()
    func pushProfileSetViewController()
    func pushSignUpFinshViewController()
    func twoViewPop()
    func finishView()
}
