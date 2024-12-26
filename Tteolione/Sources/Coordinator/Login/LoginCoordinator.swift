//
//  LoginCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class LoginCoordinator: Coordinator, LoginViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var delegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        navigationController.viewControllers = [loginVC]
    }

    func showSignUpView() {
        delegate?.didRequestSignUp(self)
    }

}
