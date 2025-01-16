//
//  LoginCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class LoginCoordinator: LoginCoordinatorDelegate {
    
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
        let reactor = LoginReactor(networkProvider: dependency.userSessionProvider,
                                   ud: dependency.ud)
        let viewController = createViewController(
            ofType: LoginViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }

    func showSignUpView() {
        let coordinator = EmailAuthCoordinator(navigationController: navigationController,
                                               dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindIDView() {
        let coordinator = ResetPasswordCoordinator(navigationController: navigationController,
                                 dependency: dependency,
                                 type: .id)
//        let coordinator = FindIDCoordinator(navigationController: navigationController,
//                                            dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindPasswordView() {
        let coordinator = ResetPasswordCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   type: .password)
//        let coordinator = FindIDCoordinator(navigationController: navigationController,
//                                            dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showAddressView() {
        let coordinator = AddressCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
}
