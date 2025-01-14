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
//    var delegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    
    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        let reactor = LoginReactor()
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
        
    }
    
    func showFindPasswordView() {
        
    }
    
    func showAddressView() {
        
    }
    
}
