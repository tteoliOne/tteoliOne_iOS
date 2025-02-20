//
//  ProductDetailCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import UIKit

final class ProductDetailCoordinator: ProductDetailCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let productId: Int
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         productId: Int) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.productId = productId
    }
    
    func start() {
        pushProductDetailViewController()
    }
    
}

extension ProductDetailCoordinator {
    
    func pushProductDetailViewController() {
        let reactor = ProductDetailReactor(networkProductProvider: dependency.productServiceProvider,
                                           networkChatProvider: dependency.chatNetworkProvider,
                                           productId: productId)
        let viewController = createViewController(
            ofType: ProductDetailViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        viewController.hidesBottomBarWhenPushed = true
        show(viewController)
    }
    
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
    
    func showReportView(reportType: ReportType, reportId: Int) {
        let coordinator = ReportCoordinator(navigationController: navigationController,
                                            dependency: dependency,
                                            reportType: reportType,
                                            reportId: reportId)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showChatView(chatId: Int, productId: Int, opponentName: String) {
        let coordinator = ChattingCoordinator(navigationController: navigationController,
                                              dependency: dependency,
                                              chatId: chatId,
                                              productId: productId,
                                              title: opponentName)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showOpponentView(userId: Int) {
        let coordinator = OpponentCoordinator(navigationController: navigationController,
                                              dependency: dependency,
                                              userId: userId)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
