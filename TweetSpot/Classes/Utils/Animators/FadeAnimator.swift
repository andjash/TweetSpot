//
//  FadeAnimator.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private final let presenting: Bool
    private final let completion: (() -> ())?
    
    convenience init(presenting: Bool) {
        self.init(presenting: presenting, completion: nil)
    }
    
    init(presenting: Bool, completion: (() -> ())?) {
        self.presenting = presenting
        self.completion = completion
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!;
        toViewController.view.alpha = 0.0;
        
        toViewController.view.frame = (transitionContext.containerView.bounds)
        transitionContext.containerView.addSubview(toViewController.view)
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
        }, completion: { (completed) in
            let success = !transitionContext.transitionWasCancelled;
            
            if (self.presenting && !success) || (!self.presenting && success) {
                toViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
            self.completion?()
        }) 
    }
    
}
