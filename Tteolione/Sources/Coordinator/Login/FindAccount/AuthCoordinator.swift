//
//  AuthCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import UIKit

final class AuthCoordinator: AuthViewControllerDelegate {
    
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
        let reactor = AuthReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: AuthViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showFindIDResult(with dto: FindIDDTO) {
        let authNumCoordinator = FindIDResultCoordinator(
            navigationController: navigationController,
            dependency: dependency,
            dto: dto
        )
        
        addChildCoordinator(authNumCoordinator)
        authNumCoordinator.start()
    }
    
}
