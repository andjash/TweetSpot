//
//  FadeInSegue.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit


private var associationHandle: UInt8 = 0

class FadeInSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
     override func perform() {
        let delegate = FadeTransitionDelegate()
        objc_setAssociatedObject(destinationViewController, &associationHandle, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        destinationViewController.transitioningDelegate = delegate
        sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
    }
}

private class FadeTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    @objc func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: true)
    }
    
    @objc func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: false, completion: {
            objc_setAssociatedObject(dismissed,  &associationHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        })
    }
}