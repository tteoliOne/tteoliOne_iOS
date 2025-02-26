//
//  UIView+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 1/25/25.
//

import UIKit
import Toast

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

extension UIView {
    private static let loadingViewTag = 99999

    func showLoadingToast() {
        if self.viewWithTag(UIView.loadingViewTag) != nil { return }
        
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingView.layer.cornerRadius = 10
        loadingView.tag = UIView.loadingViewTag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = CGPoint(x: loadingView.bounds.width / 2, y: loadingView.bounds.height / 2)
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        loadingView.center = self.center

        self.addSubview(loadingView)
    }

    func hideLoadingToast() {
        self.viewWithTag(UIView.loadingViewTag)?.removeFromSuperview()
    }
}
