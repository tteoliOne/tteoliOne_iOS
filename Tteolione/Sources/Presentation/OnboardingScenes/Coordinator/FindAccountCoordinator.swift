//
//  FindAccountCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import UIKit

final class FindAccountCoordinator: FindAccountCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    var type: AccountCoordinator
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         type: AccountCoordinator) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.type = type
    }
    
    func start() {
        switch type {
        case .id:
            pushFindIdViewController()
            
        case .password:
            pushResetPasswordChcekViewController(viewType: .password)
            
        case .idInPassword:
            pushResetPasswordChcekViewController(viewType: .idInPassword)
        }
    }
    
}

extension FindAccountCoordinator {
    
    func pushFindIdViewController() {
        let reactor = FindIDReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator
        )
        let viewController = createViewController(
            ofType: FindIDViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushResultIdViewController(with resultData: FindIDDTO) {
        let reactor = FindIDResultReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator,
            dto: resultData
        )
        let viewController = createViewController(
            ofType: FindIDResultViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushResetPasswordChcekViewController(viewType: AccountCoordinator) {
        let reactor = ResetPasswordCheckReactor(networkProvider: dependency.accountNetworkProvider,
                                                mediator: dependency.onboardingMediator,
                                                viewType: viewType)
        let viewController = createViewController(
            ofType: ResetPasswordCheckViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushAuthViewController(viewType: AccountCoordinator) {
        let reactor = AuthReactor(
            networkProvider: dependency.accountNetworkProvider,
            mediator: dependency.onboardingMediator,
            viewType: viewType
        )
        let viewController = createViewController(
            ofType: AuthViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushResetPasswordViewController() {
        let reactor = ResetPasswordReactor(networkProvider: dependency.accountNetworkProvider,
                                           mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: ResetPasswordViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func finishView() {
        finishAllChildren()
        navigationController.popToRootViewController(animated: true)
    }
    
}
