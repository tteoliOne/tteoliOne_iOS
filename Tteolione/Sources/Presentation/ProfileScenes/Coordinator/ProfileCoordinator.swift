//
//  ProfileCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class ProfileCoordinator: NSObject, ProfileCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    
    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        let reactor = ProfileReactor(networkProvider: dependency.userProvider)
        let viewController = createViewController(
            ofType: ProfileViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
}
