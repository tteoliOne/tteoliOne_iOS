//
//  ViewController+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 12/10/24.
//

import UIKit

extension UIViewController {
    
    func navigateToScreen(_ scenes: UIViewController) {
        let viewController = scenes
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
