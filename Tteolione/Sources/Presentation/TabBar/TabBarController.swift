//
//  TabBarController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    init() {
        super.init(
            nibName: nil,
            bundle: nil
        )
        configureTabBarAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
}
