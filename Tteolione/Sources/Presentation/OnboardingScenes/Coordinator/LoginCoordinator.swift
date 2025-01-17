//
//  LoginCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 12/19/24.
//

import UIKit

final class LoginCoordinator: LoginCoordinatorDelegate {
    
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
        let reactor = LoginReactor(kakaoAuthVM: dependency.kakaoManager,
                                   appleAuthManager: dependency.appleManager,
                                   networkProvider: dependency.userSessionProvider,
                                   ud: dependency.ud)
        let viewController = createViewController(
            ofType: LoginViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }

    func showSignUpView() {
        let coordinator = JoinCoordinator(navigationController: navigationController,
                                          dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindIDView() {
        let coordinator = FindAccountCoordinator(navigationController: navigationController,
                                 dependency: dependency,
                                 type: .id)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showFindPasswordView() {
        let coordinator = FindAccountCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   type: .password)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func pushAddressView() {
        let reactor = AddressReactor(ud: dependency.ud)
        let viewController = createViewController(
            ofType: AddressViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushKakaoSetProfileView(with token: String) {
        let reactor = ProfileSetReactor(loginType: .kakao(dependency.socialNetworkProvider),
                                        mediator: dependency.onboardingMediator,
                                        ud: dependency.ud,
                                        token: token)
        let viewController = createViewController(
            ofType: SocialProfileSetViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func pushAppleSetProfileView(with token: String) {
        let reactor = ProfileSetReactor(loginType: .apple(dependency.socialNetworkProvider),
                                        mediator: dependency.onboardingMediator,
                                        ud: dependency.ud,
                                        token: token)
        let viewController = createViewController(
            ofType: SocialProfileSetViewController.self,
            with: reactor,
            delegate: self
        )
        
        show(viewController)
    }
    
    func finishView() {
        finishAllChildren()
        navigationController.popToRootViewController(animated: true)
    }
    
    func goHome() {
        finishAllChildren()
        parentCoordinator?.start()
    }
    
}
