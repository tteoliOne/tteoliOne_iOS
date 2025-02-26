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
                   cancelTitle: String? = nil,
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        okAction.setValue(UIColor.myAppMain, forKey: "titleTextColor")
        alert.addAction(okAction)
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.myAppMain, forKey: "titleTextColor")
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func addChild(_ childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
    }
    
    func removeChild(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
}
