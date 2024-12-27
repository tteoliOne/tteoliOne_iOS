//
//  AppCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginViewController()
    }
    
    private func showLoginViewController() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    
    func didRequestSignUp(_ coordinator: LoginCoordinator) {
        removeChildCoordinators(ofType: type(of: coordinator))
        let signUpCoordinator = EmailAuthCoordinator(
            navigationController: navigationController,
            dependency: AppDependency.shared
        )
        addChildCoordinator(signUpCoordinator)
        signUpCoordinator.start()
    }
    
}
