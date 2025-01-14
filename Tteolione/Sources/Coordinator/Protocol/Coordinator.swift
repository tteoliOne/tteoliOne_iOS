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
    func finsh()
    func popVC()
    func dismissVC()
    func show<T: UIViewController>(_ viewController: T, as style: PresentationStyle)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func finsh() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
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

enum PresentationStyle {
    case push
    case present
}
