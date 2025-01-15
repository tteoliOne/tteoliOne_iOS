//
//  SignUpFinshCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import UIKit

final class SignUpFinshCoordinator: SignUpFinshViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SignUpFinshViewController()
        viewController.delegate = self
        show(viewController)
    }
    
    func showLogin() {
//        parentCoordinator?.removeChildCoordinators(ofTypes: [
//            EmailAuthCoordinator.self,
//            AuthNumCoordinator.self,
//            NameCoordinator.self,
//            IDCoordinator.self,
//            PasswordCoordinator.self,
//            NicknameCoordinator.self,
//            ProfileSetCoordinator.self,
//            SignUpFinshCoordinator.self
//        ])
        
        navigationController.popToRootViewController(animated: true)
    }
    
}
