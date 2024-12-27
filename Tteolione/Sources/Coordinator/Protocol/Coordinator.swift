//
//  Coordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit
import ReactorKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    func start()
    func popToPreviousScreen()
    func show<T: UIViewController>(_ viewController: T)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinators<T>(ofType type: T.Type) {
            childCoordinators.removeAll { $0 is T }
        }
        
    func removeChildCoordinators(ofTypes types: [Coordinator.Type]) {
        childCoordinators.removeAll { coordinator in
            types.contains(where: { $0 == type(of: coordinator) })
        }
    }
    
    func popToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func show<T: UIViewController>(_ viewController: T) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension Coordinator {
    
    func createViewController<T: UIViewController & ReactorKit.View & DelegateOwner,
                              R: Reactor>(ofType type: T.Type,
                                          with reactor: R,
                                          delegate: T.Delegate?) -> T where T.Reactor == R {
        var viewController = T()
        viewController.reactor = reactor
        viewController.delegate = delegate
        return viewController
    }
}

protocol DelegateOwner {
    associatedtype Delegate
    var delegate: Delegate? { get set }
}
