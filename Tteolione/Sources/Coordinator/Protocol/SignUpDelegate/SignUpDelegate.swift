//
//  SignUpDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 12/22/24.
//

import Foundation

protocol SignUpCoordinatorDelegate {
    func didRequestSignUp(_ coordinator: LoginCoordinator)
}

protocol SignUpViewControllerDelegate {
    func showEmailAuth()
    func showAuthNum()
    func showID()
    func showPassword()
    func showNickname()
    func showProfileSet()
}
