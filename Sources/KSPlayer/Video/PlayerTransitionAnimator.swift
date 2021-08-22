//
//  PlayerTransitionAnimator.swift
//  KSPlayer
//
//  Created by kintan on 2021/8/20.
//

#if canImport(UIKit)
import UIKit
class PlayerTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let isDismiss: Bool
    private let containerView: UIView
    private let animationView: UIView
    init(containerView: UIView, animationView: UIView, isDismiss: Bool = false) {
        self.containerView = containerView
        self.animationView = animationView
        self.isDismiss = isDismiss
        super.init()
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animationSuperView = animationView.superview
        let initSize = animationView.frame.size
        guard let presentedView = transitionContext.view(forKey: .to) else {
            return
        }
        if isDismiss {
            containerView.layoutIfNeeded()
        } else {
            if let viewController = transitionContext.viewController(forKey: .to) {
                presentedView.frame = transitionContext.finalFrame(for: viewController)
            }
            presentedView.layoutIfNeeded()
        }
        transitionContext.containerView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = true
        guard let transform = transitionContext.viewController(forKey: .from)?.view.transform else {
            return
        }
        animationView.transform = CGAffineTransform(scaleX: initSize.width / animationView.frame.size.width, y: initSize.height / animationView.frame.size.height).concatenating(transform)
        let fromCenter = transitionContext.view(forKey: .from)?.convert(containerView.center, to: nil) ?? .zero
        let toCenter = transitionContext.containerView.center
        animationView.center = isDismiss ? toCenter : fromCenter
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
            self.animationView.transform = .identity
            self.animationView.center = self.isDismiss ? fromCenter : toCenter
        } completion: { _ in
            animationSuperView?.addSubview(self.animationView)
            if !self.isDismiss {
                transitionContext.containerView.addSubview(presentedView)
            }
            transitionContext.completeTransition(true)
        }
    }
}
#endif