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
    
    func pushPostViewController(viewType: PostViewType,
                                productDetail: ProductDetailDTO? = nil) {
        let coordinator = PostCoordinator(navigationController: navigationController,
                                          dependency: dependency,
                                          viewType: viewType,
                                          productDetail: productDetail)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func pushProductDetailView(productId: Int) {
        let coordinator = ProductDetailCoordinator(navigationController: navigationController,
                                                   dependency: dependency,
                                                   productId: productId)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
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
        let leftButton = UIButton()
        leftButton.setTitle("내 이", for: .normal)
        leftButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        leftButton.setTitleColor(.black, for: .normal)
        let spacing: CGFloat = 3
        let titleSize = leftButton.titleLabel?.intrinsicContentSize ?? .zero
        leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(leftButton.imageView?.frame.width ?? 0) - spacing,
                                                  bottom: 0,
                                                  right: (leftButton.imageView?.frame.width ?? 0) + spacing)
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + spacing,
                                                  bottom: 0,
                                                  right: -(titleSize.width) - spacing)
        leftButton.clipsToBounds = false
        leftButton.showsMenuAsPrimaryAction = true
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didSearchViewButton)
        )
        viewController.navigationItem.rightBarButtonItem = rightButton
        viewController.title = NavigationTitle.main.title
        viewController.navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func didSearchViewButton() {
        let coordinator = SearchCoordinator(navigationController: navigationController,
                                            dependency: dependency)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    @objc private func didTapLeftButton() {
        showSideMenu()
    }
    
}

extension MainCoordinator {
    func showSideMenu() {
        let reactor = SideMenuReactor(networkProvider: dependency.productServiceProvider)
        let viewController = createViewController(
            ofType: SideMenuViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.view.backgroundColor = .myAppSideMenu
        show(viewController, as: .present)
    }
}

extension MainCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuAnimator(isPresenting: false)
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
