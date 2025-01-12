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
        configureNavBarAppearance()
        configureNavBarButtons(for: mainViewController)
        navigationController.setViewControllers([mainViewController], animated: false)
    }
}

extension MainCoordinator {
    
    private func configureNavBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.myAppMain,
            .font: Font.Andong25
        ]
        
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController.navigationBar.compactAppearance = navigationBarAppearance
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = .myAppBlack
    }
    
    private func configureNavBarButtons(for viewController: UIViewController) {
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("내 이", for: .normal)
        leftButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.showsMenuAsPrimaryAction = true
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil
        )
        viewController.navigationItem.rightBarButtonItem = rightButton
        viewController.title = NavigationTitle.main.title
        viewController.navigationItem.largeTitleDisplayMode = .never
    }
    
}
