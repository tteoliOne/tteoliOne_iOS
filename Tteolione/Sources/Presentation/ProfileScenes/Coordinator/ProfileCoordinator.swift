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
        let reactor = ProfileReactor(networkProvider: dependency.userProvider,
                                     userSessionNetworkProvider: dependency.userSessionProvider)
        let viewController = createViewController(
            ofType: ProfileViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
}

extension ProfileCoordinator {
    func pushMyProductViewController(status: StatusType) {
        let reactor = MyProductListReactor(networkProvider: dependency.userProvider,
                                           status: status)
        let viewController = createViewController(
            ofType: MyProductListViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
    
    func pushMyReviewViewController() {
        let reactor = MyReviewReactor(networkProvider: dependency.userProvider)
        let viewController = createViewController(
            ofType: MyReviewViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
    
    func pushDetailViewController(productId: Int) {
        let coordinator = ProductDetailCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   productId: productId)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showSettingView() {
        let coordinator = SettingCoordinator(navigationController: navigationController,
                                             dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
