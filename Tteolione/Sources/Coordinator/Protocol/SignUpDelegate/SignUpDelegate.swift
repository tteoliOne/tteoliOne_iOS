//
//  SignUpDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 12/22/24.
//

import Foundation

protocol EmailAuthCoordinatorDelegate {
    func showAuthNum(_ coordinator: AuthNumCoordinator)
}

protocol EmailAuthViewControllerDelegate {
    func popToPreviousScreen()
    func showAuthNum()
    func showEmailAuth()
}

protocol AuthNumViewControllerDelegate {
    func showAuthNum()
}

protocol IDViewControllerDelegate {
    func showID()
}

protocol PasswordViewControllerDelegate {
    func showPassword()
}

protocol NicknameViewControllerDelegate {
    func showNickname()
}

protocol ProfileSetViewControllerDelegate {
    func showProfileSet()
}
