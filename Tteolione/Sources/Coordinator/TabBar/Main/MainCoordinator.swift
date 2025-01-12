//
//  MainCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController()
        navigationController.setViewControllers([mainViewController], animated: false)
    }
}
