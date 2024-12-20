//
//  LoginDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 12/20/24.
//

import Foundation

protocol LoginCoordinatorDelegate {
    func didRequestSignUp(_ coordinator: LoginCoordinator)
}

protocol LoginViewControllerDelegate {
    func showSignUpView()
}
