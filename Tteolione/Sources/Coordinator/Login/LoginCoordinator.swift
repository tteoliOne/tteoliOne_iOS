//
//  LoginCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class LoginCoordinator: Coordinator, LoginViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        self.navigationController.viewControllers = [loginVC]
    }

    func showSignUpView() {
        delegate?.didRequestSignUp(self)
    }

}
