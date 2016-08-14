//
//  FadeInSegue.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class FadeInSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
    override func perform() {
        objc_setAssociatedObject(self, "FadeInSegue.DismissAnimator", self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        destinationViewController.transitioningDelegate = self
        sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: false, completion: { [unowned self] in
            objc_removeAssociatedObjects(self)
        })
    }
}
