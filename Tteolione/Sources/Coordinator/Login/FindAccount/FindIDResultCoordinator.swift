////
////  FindIDResultCoordinator.swift
////  Tteolione
////
////  Created by 전준영 on 1/8/25.
////
//
//import UIKit
//
//final class FindIDResultCoordinator: FindIDResultCoordinatorDelegate {
//    
//    var childCoordinators: [Coordinator] = []
//    var navigationController: UINavigationController
//    var parentCoordinator: Coordinator?
//    private let dependency: AppDependency
//    private let dto: FindIDDTO
//    
//    init(navigationController: UINavigationController,
//         dependency: AppDependency,
//         dto: FindIDDTO
//    ) {
//        self.navigationController = navigationController
//        self.dependency = dependency
//        self.dto = dto
//    }
//    
//    func start() {
//        let reactor = FindIDResultReactor(
//            networkProvider: dependency.accountNetworkProvider,
//            mediator: dependency.onboardingMediator,
//            dto: dto
//        )
//        let viewController = createViewController(
//            ofType: FindIDResultViewController.self,
//            with: reactor,
//            delegate: self
//        )
//        
//        show(viewController)
//    }
//    
//    func showPasswordResetView() {
//        let authNumCoordinator = AuthNumCoordinator(
//            navigationController: navigationController,
//            dependency: dependency
//        )
//        
//        addChildCoordinator(authNumCoordinator)
//        authNumCoordinator.start()
//    }
//    
//    func goToLogin() {
//        finishAllChildren()
//        parentCoordinator?.finish()
//        navigationController.popToRootViewController(animated: true)
//    }
//
//}
