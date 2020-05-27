//
//  SmoothPresentAnimationController.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SmoothPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame : CGRect
    private let destenationFrame : CGRect
    private let image : UIImage?
    
    init(image : UIImage?, originFrame : CGRect, destenationFrame : CGRect) {
        self.image = image
        self.originFrame = originFrame
        self.destenationFrame = destenationFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let imageView = AvatarImage(borderWidth: ImageBorders.medium)
        configureImageView(imageView)
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        toVC.view.alpha = 0
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
          withDuration: duration,
          delay: 0,
          options: .calculationModeLinear,
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2/3) {
                imageView.transform = CGAffineTransform.identity
                imageView.center = CGPoint(x: self.destenationFrame.midX, y: self.destenationFrame.midY)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                toVC.view.alpha = 1
            }
        },
          completion: { _ in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func configureImageView(_ imageView : AvatarImage) {
        imageView.frame = CGRect(origin: originFrame.origin, size: destenationFrame.size)
        imageView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        imageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        imageView.configure(image: image)
    }
}
