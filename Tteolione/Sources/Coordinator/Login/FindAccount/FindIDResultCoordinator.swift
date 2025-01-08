//
//  FindIDResultCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import UIKit

final class FindIDResultCoordinator: FindIDResultViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    private let dependency: AppDependency
    private let dto: FindIDDTO
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         dto: FindIDDTO) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.dto = dto
    }
    
    func start() {
        let reactor = FindIDResultReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator,
            dto: dto
        )
        let viewController = createViewController(
            ofType: FindIDResultViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func showFindIDResult() {
        let authNumCoordinator = AuthNumCoordinator(
            navigationController: navigationController,
            dependency: dependency
        )
        
        addChildCoordinator(authNumCoordinator)
        authNumCoordinator.start()
    }
    
}
