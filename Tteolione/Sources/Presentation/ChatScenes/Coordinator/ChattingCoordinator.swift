//
//  ChattingCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import UIKit

final class ChattingCoordinator: ChattingCoordinatorDelegate {
    
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
        let reactor = ChattingReactor()
        let viewController = createViewController(
            ofType: ChattingViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.hidesBottomBarWhenPushed = true
        show(viewController)
    }
}
