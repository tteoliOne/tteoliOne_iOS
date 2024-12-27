//
//  IDCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/26/24.
//

import UIKit

final class IDCoordinator: IDViewControllerDelegate {
    
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
        let reactor = IDReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        let viewController = createViewController(
            ofType: IDViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showPassword() {
        let passwordCoordinator = PasswordCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(passwordCoordinator)
        passwordCoordinator.parentCoordinator = self
        passwordCoordinator.start()
    }
    
}
