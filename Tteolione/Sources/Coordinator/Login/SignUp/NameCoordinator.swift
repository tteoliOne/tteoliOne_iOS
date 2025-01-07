//
//  NameCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/28/24.
//

import UIKit

final class NameCoordinator: NameViewControllerDelegate {
    
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
        let reactor = NameReactor(
            networkProvider: dependency.joinNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: NameViewController.self,
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
