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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
