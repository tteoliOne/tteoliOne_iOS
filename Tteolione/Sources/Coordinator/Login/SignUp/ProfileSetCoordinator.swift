//
//  ProfileSetCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import UIKit

final class ProfileSetCoordinator: ProfileSetViewControllerDelegate {
    
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
        let reactor = ProfileSetReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        let viewController = createViewController(
            ofType: ProfileSetViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showFinshSignUp() {
        let authNumCoordinator = SignUpFinshCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(authNumCoordinator)
        authNumCoordinator.parentCoordinator = self
        authNumCoordinator.start()
    }
    
}
