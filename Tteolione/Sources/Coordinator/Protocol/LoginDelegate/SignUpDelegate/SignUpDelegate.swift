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

protocol EmailAuthViewControllerDelegate: Coordinator {
    func showAuthNum()
}

protocol AuthNumViewControllerDelegate: AnyObject, Coordinator {
    func showName()
}

protocol NameViewControllerDelegate: AnyObject, Coordinator {
    func showID()
}

protocol IDViewControllerDelegate: AnyObject, Coordinator {
    func showPassword()
}

protocol PasswordViewControllerDelegate: AnyObject, Coordinator {
    func showNickname()
}

protocol NicknameViewControllerDelegate: AnyObject, Coordinator {
    func showProfileSet()
}

protocol ProfileSetViewControllerDelegate: AnyObject, Coordinator {
    func showFinshSignUp()
}

protocol SignUpFinshViewControllerDelegate: AnyObject, Coordinator {
    func showLogin()
}
