//
//  EmailAuthCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class EmailAuthCoordinator: EmailAuthViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    private let dependency: AppDependency
    
    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        let reactor = EmailAuthReactor(
            networkProvider: dependency.joinNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: EmailAuthViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showAuthNum() {
        let authNumCoordinator = AuthNumCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        
        addChildCoordinator(authNumCoordinator)
        authNumCoordinator.start()
    }
    
}
