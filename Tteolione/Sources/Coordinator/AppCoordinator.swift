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
//        showLoginViewController()
        
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
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
        let signUpCoordinator = EmailAuthCoordinator(
            navigationController: navigationController,
            dependency: AppDependency.shared
        )
        addChildCoordinator(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func didRequestFindID(_ coordinator: LoginCoordinator) {
        let findIDCoordinator = FindIDCoordinator(
            navigationController: navigationController,
            dependency: AppDependency.shared)
        addChildCoordinator(findIDCoordinator)
        findIDCoordinator.start()
    }
    
}
