//
//  FadeInSegue.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

private var associationHandle: UInt8 = 0

final class FadeInSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {
    
     override func perform() {
        let delegate = FadeTransitionDelegate()
        objc_setAssociatedObject(destination, &associationHandle, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        destination.transitioningDelegate = delegate
        source.present(self.destination, animated: true, completion: nil)
    }
}

private final class FadeTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator(presenting: false, completion: {
            objc_setAssociatedObject(dismissed,  &associationHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        })
    }
}
