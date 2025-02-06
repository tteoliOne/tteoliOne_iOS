//
//  SlideInPresentationAnimator.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit

final class SlideInPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let direction: CATransitionSubtype
    let isPresentation: Bool
    
    init(direction: CATransitionSubtype, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.x = direction == .fromRight ? presentedFrame.width : -presentedFrame.width
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                controller.view.frame = finalFrame
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
            }
        )
    }

}
