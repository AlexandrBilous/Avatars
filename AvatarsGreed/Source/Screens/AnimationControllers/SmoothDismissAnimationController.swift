//
//  SmoothDismissAnimationController.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class SmoothDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
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
        guard let toVC = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.view(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC, at: 0)
        toVC.alpha = 0
        let imageView = AvatarImage(borderWidth: 0)
        containerView.addSubview(fromVC)
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        containerView.addSubview(imageView)
        configureImageView(imageView)
        let duration = transitionDuration(using: transitionContext)

        UIView.animateKeyframes(
          withDuration: duration,
          delay: 0,
          options: .calculationModeCubic,
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3) {
                fromVC.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 2/3) {
                toVC.alpha = 1.0
                imageView.transform = CGAffineTransform.identity
                imageView.frame.origin = self.destenationFrame.origin
            }
        },
          completion: { _ in
            toVC.isHidden = false
            imageView.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
              toVC.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func configureImageView(_ imageView : AvatarImage) {
        imageView.frame = CGRect(origin: originFrame.origin, size: destenationFrame.size)
        imageView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        imageView.transform = CGAffineTransform(scaleX: originFrame.width / destenationFrame.width,
                                                y: originFrame.height / destenationFrame.height)
        imageView.configure(image: image)
    }
}
