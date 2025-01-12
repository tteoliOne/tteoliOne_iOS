//
//  TabBarCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let tabBarController: TabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
    }
    
    func start() {
        setupTabBarController()
    }
    
}

extension TabBarCoordinator {
    private func setupTabBarController() {
        let viewControllers = TabBase.allCases.map { tabBase in
            makeNavigationController(for: tabBase)
        }
        tabBarController.viewControllers = viewControllers
        tabBarController.tabBar.tintColor = .myAppBlack
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func makeNavigationController(for tabBase: TabBase) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(
            title: tabBase.tabTitle,
            image: tabBase.unselectedImage,
            selectedImage: tabBase.selectedImage
        )
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        setupChildCoordinator(for: tabBase, navigationController: navigationController)
        
        return navigationController
    }
    
    private func setupChildCoordinator(for tabBase: TabBase, navigationController: UINavigationController) {
        let coordinator: Coordinator
        
        switch tabBase {
        case .main:
            coordinator = MainCoordinator(navigationController: navigationController)
            
        case .chat:
            coordinator = MainCoordinator(navigationController: navigationController)
            
        case .myProfile:
            coordinator = MainCoordinator(navigationController: navigationController)
        }
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
