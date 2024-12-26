//
//  EmailAuthCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class EmailAuthCoordinator: Coordinator, EmailAuthViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    private let dependency: AppDependency

    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }

    func start() {
        showEmailAuth()
    }

    func popToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func showEmailAuth() {
        let viewController = EmailAuthViewController()
        let reactor = EmailAuthReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        viewController.reactor = reactor
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAuthNum() {
        let authNumCoordinator = AuthNumCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(authNumCoordinator)
        authNumCoordinator.parentCoordinator = self
        authNumCoordinator.start()
    }
    
}
