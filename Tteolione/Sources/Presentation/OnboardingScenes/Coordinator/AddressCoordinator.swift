//
//  AddressCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import UIKit

final class AddressCoordinator: NSObject, AddressCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let viewType: AddressViewType
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         viewType: AddressViewType) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.viewType = viewType
    }
    
    deinit {
        print("deinit address")
    }
    
    func start() {
        let reactor = AddressReactor(viewType: viewType)
        let viewController = createViewController(
            ofType: AddressViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(true, animated: false)
        show(viewController)
    }
}

extension AddressCoordinator {
    func goHome() {
        finishAllChildren()
        parentCoordinator?.start()
    }
    
    func finshView() {
        finishAllChildren()
        popVC()
    }
}
