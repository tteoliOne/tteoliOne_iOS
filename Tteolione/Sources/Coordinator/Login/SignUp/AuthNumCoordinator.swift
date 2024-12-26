//
//  AuthNumCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/26/24.
//

import UIKit

final class AuthNumCoordinator: Coordinator, AuthNumViewControllerDelegate {
    
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
        showAuthNum()
    }

    func showAuthNum() {
        let viewController = AuthNumViewController()
        let reactor = AuthNumReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        viewController.reactor = reactor
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
