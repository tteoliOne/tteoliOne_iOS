//
//  ChatListCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import UIKit

final class ChatListCoordinator: ChatListCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    
    init(navigationController: UINavigationController,
         dependency: AppDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    deinit {
        print("deinit")
    }
    
    func start() {
        let reactor = ChatListReactor(networkChatProvider: dependency.chatNetworkProvider)
        let viewController = createViewController(
            ofType: ChatListViewController.self,
            with: reactor,
            delegate: self
        )
        show(viewController)
    }
}

extension ChatListCoordinator {
    func showChatView(chatId: Int,
                      productId: Int,
                      opponentName: String) {
        let coordinator = ChattingCoordinator(navigationController: navigationController,
                                              dependency: dependency,
                                              chatId: chatId,
                                              productId: productId,
                                              title: opponentName)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}
