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
        let reactor = LoginReactor(kakaoAuthVM: dependency.kakaoManager,
                                   appleAuthManager: dependency.appleManager,
                                   networkProvider: dependency.userSessionProvider,
                                   ud: dependency.ud)
        let viewController = createViewController(
            ofType: LoginViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }

    func showSignUpView() {
        let coordinator = JoinCoordinator(navigationController: navigationController,
                                          dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindIDView() {
        let coordinator = FindAccountCoordinator(navigationController: navigationController,
                                 dependency: dependency,
                                 type: .id)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindPasswordView() {
        let coordinator = FindAccountCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   type: .password)
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
