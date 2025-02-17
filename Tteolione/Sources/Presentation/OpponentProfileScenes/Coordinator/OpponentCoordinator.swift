//
//  OpponentCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/16/25.
//

import UIKit

final class OpponentCoordinator: NSObject, OpponentCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let userId: Int
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         userId: Int) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.userId = userId
    }
    
    func start() {
        let reactor = OpponentReactor(networkUserProvider: dependency.userProvider,
                                      userId: userId)
        let viewController = createViewController(
            ofType: OpponentViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
    
}

extension OpponentCoordinator {
    func finishView() {
        finishAllChildren()
        popVC()
    }
}
