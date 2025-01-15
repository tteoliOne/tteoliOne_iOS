//
//  AddressCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import UIKit

final class AddressCoordinator: AddressCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = AddressReactor()
        let viewController = createViewController(
            ofType: AddressViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func changeToMain() {
        finish()
        parentCoordinator?.start()
    }
}
