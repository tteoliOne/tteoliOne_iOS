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
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        let viewController = createViewController(
            ofType: AuthNumViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showID() {
        let idCoordinator = IDCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(idCoordinator)
        idCoordinator.parentCoordinator = self
        idCoordinator.start()
    }
    
}
