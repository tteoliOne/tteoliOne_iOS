//
//  ChatListCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 2/10/25.
//

import Foundation

protocol ChatListCoordinatorDelegate: Coordinator {
    func showChatView(chatId: Int, productId: Int)
}
