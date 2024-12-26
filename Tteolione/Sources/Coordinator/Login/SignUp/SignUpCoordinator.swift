//
//  SignUpCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class SignUpCoordinator: Coordinator, SignUpViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependency: AppDependency

    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }

    func start() {
        showEmailAuth()
    }

    func showEmailAuth() {
        let viewController = EmailAuthViewController()
        let reactor = EmailAuthReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        viewController.reactor = reactor
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAuthNum() {
        let viewController = AuthNumViewController()
        let reactor = AuthNumReactor(
            networkProvider: dependency.networkProvider,
            mediator: dependency.signUpMediator
        )
        viewController.reactor = reactor
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showID() {
        
    }
    
    func showPassword() {
        
    }
    
    func showNickname() {
        
    }
    
    func showProfileSet() {
        
    }
    
}
