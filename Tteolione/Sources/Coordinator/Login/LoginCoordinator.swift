//
//  LoginCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class LoginCoordinator: LoginViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var delegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = LoginReactor()
        let viewController = createViewController(
            ofType: LoginViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }

    func showSignUpView() {
        delegate?.didRequestSignUp(self)
    }
    
    func showFindIDView() {
        
    }

}
