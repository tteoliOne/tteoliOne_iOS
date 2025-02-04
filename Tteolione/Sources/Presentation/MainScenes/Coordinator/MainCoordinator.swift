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
    
    func pushPostViewController() {
        let reactor = PostReactor()
        let viewController = createViewController(
            ofType: PostViewController.self,
            with: reactor,
            delegate: self
        )
        show(viewController)
    }
    
    func pushProductDetailViewController(productId: Int) {
        let reactor = ProductDetailReactor(networkProvider: dependency.productServiceProvider,
                                           productId: productId)
        let viewController = createViewController(
            ofType: ProductDetailViewController.self,
            with: reactor,
            delegate: self
        )
        show(viewController)
    }
    
    func pushMapViewController() {
        let reactor = MapReactor()
        let viewController = createViewController(
            ofType: MapViewController.self,
            with: reactor,
            delegate: self
        )
        if let postViewController = navigationController.viewControllers.last as? PostViewController {
            viewController.delegates = postViewController
        }
        let rightButton = UIBarButtonItem(title: "완료",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapDoneButton))
        viewController.navigationItem.rightBarButtonItem = rightButton
        show(viewController)
    }
    
    func pushPostReceiptViewController(with productRequestBody: ProductRequestBody,
                                       productImages: [UIImage]) {
        let reactor = PostReceiptReactor(networkProvider: dependency.productServiceProvider,
                                         response: productRequestBody,
                                         images: productImages)
        let viewController = createViewController(
            ofType: PostReceiptViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.modalPresentationStyle = .pageSheet
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
        show(viewController, as: .present)
    }
    
    func dismissAndPop() {
        navigationController.dismiss(animated: true) { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
    }
    
    @objc private func didTapDoneButton() {
        if let mapViewController = navigationController.viewControllers.last as? MapViewController {
            mapViewController.completeSelection()
        }
        navigationController.popViewController(animated: true)
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
