//
//  SettingCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit

final class SettingCoordinator: NSObject, SettingCoordinatorDelegate {
    
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
        let reactor = SettingReactor()
        let viewController = createViewController(
            ofType: SettingViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
}

extension SettingCoordinator {
    func finishView() {
        finishAllChildren()
        popVC()
    }
}
