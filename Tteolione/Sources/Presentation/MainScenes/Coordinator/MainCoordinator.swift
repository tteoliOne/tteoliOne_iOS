//
//  MainCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class MainCoordinator: NSObject, MainCoordinatorDelegate {
    
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
        let reactor = MainReactor(networkProvider: dependency.productServiceProvider)
        let viewController = createViewController(
            ofType: MainViewController.self,
            with: reactor,
            delegate: self
        )
        configureNavBarAppearance()
        configureNavBarButtons(for: viewController)
        show(viewController)
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
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
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
    
    @objc private func didTapLeftButton() {
        showSideMenu()
    }
    
}

extension MainCoordinator {
    func showSideMenu() {
        let sideMenuVC = SideMenuViewController()
        sideMenuVC.modalPresentationStyle = .custom
        sideMenuVC.transitioningDelegate = self
        navigationController.present(sideMenuVC, animated: true)
    }
}

extension MainCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresenting: false)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
