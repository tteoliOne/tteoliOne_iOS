//
//  FindIDCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import UIKit

//final class FindIDCoordinator: FindIDViewControllerDelegate {
//    
//    var childCoordinators: [Coordinator] = []
//    var navigationController: UINavigationController
//    weak var parentCoordinator: Coordinator?
//    private let dependency: AppDependency
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        let reactor = EmailAuthReactor(
//            networkProvider: dependency.networkProvider,
//            mediator: dependency.signUpMediator
//        )
//        let viewController = createViewController(
//            ofType: EmailAuthViewController.self,
//            with: reactor,
//            delegate: self
//        )
//        
//        show(viewController)
//    }
//    
//    func showAuthNum() {
//        let authNumCoordinator = AuthNumCoordinator(
//            navigationController: navigationController,
//            dependency: dependency
//        )
//        
//        addChildCoordinator(authNumCoordinator)
//        authNumCoordinator.start()
//    }
//    
//}
