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
    
    func navigateToScreen<T: UIViewController>(_ viewControllerType: T.Type, reactor: (T) -> Void) {
        let viewController = viewControllerType.init()
        reactor(viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(title: String? = nil,
                   message: String,
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
