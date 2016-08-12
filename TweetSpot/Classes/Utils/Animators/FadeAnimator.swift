//
//  FadeAnimator.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    let completion: (() -> ())?
    
    convenience init(presenting: Bool) {
        self.init(presenting: presenting, completion: nil)
    }
    
    init(presenting: Bool, completion: (() -> ())?) {
        self.presenting = presenting
        self.completion = completion
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!;
        toViewController.view.alpha = 0.0;
        
        toViewController.view.frame = (transitionContext.containerView()?.bounds)!
        transitionContext.containerView()?.addSubview(toViewController.view)
        
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            toViewController.view.alpha = 1
        }) { (completed) in
            let success = !transitionContext.transitionWasCancelled();
            
            if (self.presenting && !success) || (!self.presenting && success) {
                toViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
            self.completion?()
        }
    }
    
}
