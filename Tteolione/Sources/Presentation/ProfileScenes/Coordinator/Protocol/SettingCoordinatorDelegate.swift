//
//  SettingCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import Foundation

protocol SettingCoordinatorDelegate: Coordinator {
    func pushProfileSettingView()
    func pushProfileResetPasswordView()
    func pushAddressSettingView()
    func finishView()
}
