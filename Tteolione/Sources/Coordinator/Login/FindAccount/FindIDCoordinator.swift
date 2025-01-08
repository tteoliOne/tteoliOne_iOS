//
//  FindIDCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import UIKit

final class FindIDCoordinator: FindIDViewControllerDelegate {
    
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
        let reactor = FindIDReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: FindIDViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showFindAuth() {
        let authNumCoordinator = AuthCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        
        addChildCoordinator(authNumCoordinator)
        authNumCoordinator.start()
    }
    
}
