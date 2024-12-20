//
//  SignUpCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class SignUpCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependency: AppDependency

    init(navigationController: UINavigationController, dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }

    func start() {
        showEmailAuth()
    }

    private func showEmailAuth() {
        let viewController = EmailAuthViewController()
        viewController.reactor = EmailAuthReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        navigationController.pushViewController(viewController, animated: true)
    }

}
