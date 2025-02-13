//
//  ChattingCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/8/25.
//

import UIKit

final class ChattingCoordinator: ChattingCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let chatId: Int
    private let productId: Int
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         chatId: Int,
         productId: Int) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.chatId = chatId
        self.productId = productId
    }
    
    deinit {
        print("deinit")
    }
    
    func start() {
        let reactor = ChattingReactor(chatId: chatId,
                                      productId: productId,
                                      networkChatProvider: dependency.chatNetworkProvider)
        let viewController = createViewController(
            ofType: ChattingViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        show(viewController)
    }
}

extension ChattingCoordinator {
    func finishView() {
        finishAllChildren()
    }
}
