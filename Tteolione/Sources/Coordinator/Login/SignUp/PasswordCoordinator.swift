//
//  PasswordCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import UIKit

final class PasswordCoordinator: PasswordViewControllerDelegate {
    
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
        let reactor = PasswordReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        let viewController = createViewController(
            ofType: PasswordViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showNickname() {
        let nicknameCoordinator = NicknameCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(nicknameCoordinator)
        nicknameCoordinator.parentCoordinator = self
        nicknameCoordinator.start()
    }
    
}
