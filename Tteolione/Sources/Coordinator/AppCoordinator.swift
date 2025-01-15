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
        let loginCoordinator = LoginCoordinator(navigationController: navigationController,
                                                dependency: AppDependency.shared)
        loginCoordinator.parentCoordinator = self
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
}
