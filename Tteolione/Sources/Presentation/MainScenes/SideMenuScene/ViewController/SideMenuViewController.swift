//
//  SideMenuViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit

final class SideMenuViewController: BaseViewController<SideMenuView> {
    
}

final class SideMenuView: BaseView {
    
}

final class SideMenuPresentationController: UIPresentationController {
    private let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        let safeAreaInsets = containerView.safeAreaInsets
        let width = containerView.bounds.width * 0.5
        
        presentedView.frame = CGRect(
            x: 0,
            y: safeAreaInsets.top,
            width: width,
            height: containerView.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        )
        presentedView.layer.shadowColor = UIColor.black.cgColor
        presentedView.layer.shadowOpacity = 0.3
        presentedView.layer.shadowOffset = CGSize(width: 0, height: 5)
        presentedView.layer.shadowRadius = 10
        
        let path = UIBezierPath(
            roundedRect: presentedView.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        presentedView.layer.mask = mask
    }
    
}


final class SideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else { return }
            let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.frame = CGRect(x: -finalFrame.width, y: 0, width: finalFrame.width, height: finalFrame.height)
            containerView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = finalFrame
            }) { completed in
                transitionContext.completeTransition(completed)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            }) { completed in
                if completed {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(completed)
            }
        }
    }
}

