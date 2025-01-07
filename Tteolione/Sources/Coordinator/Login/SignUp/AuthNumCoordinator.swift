//
//  AuthNumCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/26/24.
//

import UIKit

final class AuthNumCoordinator: AuthNumViewControllerDelegate {
    
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
        let reactor = AuthNumReactor(
            networkProvider: dependency.joinNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: AuthNumViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showName() {
        let nameCoordinator = NameCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(nameCoordinator)
        nameCoordinator.parentCoordinator = self
        nameCoordinator.start()
    }
    
}
