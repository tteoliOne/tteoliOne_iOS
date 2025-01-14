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
    private let userDefaultManager = UserDefaultsManager.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if userDefaultManager.token.isEmpty {
            showLoginVC()
        } else {
            startTabBar()
        }
    }
    
    private func startTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = self
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func showLoginVC() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.parentCoordinator = self
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
