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
    func finish()
    func popVC()
    func dismissVC()
    func finishAllChildren()
    func removeChild(_ coordinator: Coordinator)
    func show<T: UIViewController>(_ viewController: T, as style: PresentationStyle)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func popVC() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissVC() {
        navigationController.dismiss(animated: true)
    }
    
    func show<T: UIViewController>(_ viewController: T, as style: PresentationStyle = .push) {
        switch style {
        case .push:
            navigationController.pushViewController(viewController, animated: true)
        case .present:
            navigationController.present(viewController, animated: true)
        }
    }
    
    func finishAllChildren() {
        for child in childCoordinators {
            child.finishAllChildren()
        }
        childCoordinators.removeAll()
        finish()
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension Coordinator {
    func createViewController<T: UIViewController & ReactorKit.View & DelegateOwner,
                              R: Reactor>(ofType type: T.Type,
                                          with reactor: R,
                                          delegate: T.Delegate) -> T where T.Reactor == R {
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

enum PresentationStyle {
    case push
    case present
}
