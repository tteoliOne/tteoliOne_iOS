//
//  JoinCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import UIKit

final class JoinCoordinator: JoinCoordinatorDelegate {
    
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
        pushEmailAuthViewController()
    }
    
}

extension JoinCoordinator {
    
    func pushEmailAuthViewController() {
        let reactor = EmailAuthReactor(networkProvider: dependency.joinNetworkProvider,
                                       mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: EmailAuthViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushAuthNumViewController() {
        let reactor = AuthNumReactor(networkProvider: dependency.joinNetworkProvider,
                                     mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: AuthNumViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushNameViewController() {
        let reactor = NameReactor(networkProvider: dependency.joinNetworkProvider,
                                  mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: NameViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushIdViewController() {
        let reactor = IDReactor(networkProvider: dependency.joinNetworkProvider,
                                mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: IDViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushPasswordViewController() {
        let reactor = PasswordReactor(networkProvider: dependency.joinNetworkProvider,
                                      mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: PasswordViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushNicknameViewController() {
        let reactor = NicknameReactor(networkProvider: dependency.joinNetworkProvider,
                                      mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: NicknameViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushProfileSetViewController() {
        let reactor = ProfileSetReactor(loginType: .local(dependency.joinNetworkProvider),
                                        mediator: dependency.onboardingMediator)
        let viewController = createViewController(
            ofType: ProfileSetViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushSignUpFinshViewController() {
        let reactor = SignUpFinshReactor()
        let viewController = createViewController(
            ofType: SignUpFinshViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func finishView() {
        finishAllChildren()
        navigationController.popToRootViewController(animated: true)
    }
    
    func twoViewPop() {
        guard let currentViewController = navigationController.visibleViewController,
              let currentIndex = navigationController.viewControllers.firstIndex(of: currentViewController) else {
            navigationController.popViewController(animated: true)
            return
        }
        
        let targetIndex = max(currentIndex - 2, 0)
        let targetViewController = navigationController.viewControllers[targetIndex]
        navigationController.popToViewController(targetViewController, animated: true)
    }

}
