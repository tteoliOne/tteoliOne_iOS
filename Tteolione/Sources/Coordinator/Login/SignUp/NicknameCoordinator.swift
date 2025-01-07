//
//  NicknameCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/27/24.
//

import UIKit

final class NicknameCoordinator: Coordinator, NicknameViewControllerDelegate {
    
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
        let reactor = NicknameReactor(
            networkProvider: dependency.joinNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: NicknameViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showProfileSet() {
        let authNumCoordinator = ProfileSetCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        childCoordinators.append(authNumCoordinator)
        authNumCoordinator.parentCoordinator = self
        authNumCoordinator.start()
    }
    
}
