//
//  UIViewController+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    private final class SegueConfigurationHolder<T: UIViewController>: NSObject {
        let closure: (UIViewController) -> ()
        
        init(closure: @escaping (UIViewController) -> ()) {
            self.closure = closure
        }
    }
    
    private final class Holder: NSObject {
        static var shared = Holder()
        
        final var storyboardInjections: [String : (Any) -> ()] = [:]
        
        override init() {
            super.init()
            swizzlePrepareForSegue()
        }
        
        private final func swizzlePrepareForSegue() {
            let originalSelector = #selector(UIViewController.prepare(for:sender:))
            let swizzledSelector = #selector(UIViewController.ts_swizzledPrepareForSegue(segue:sender:))
            
            let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
    }
    
    @objc private func ts_swizzledPrepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
        if let configHolder = sender as? SegueConfigurationHolder {
            configHolder.closure(segue.destination)
        }
        self.ts_swizzledPrepareForSegue(segue: segue, sender: sender)
    }
    
    
    final func ts_openController<T: UIViewController>(_ type: T.Type, storyboardId: String, configuration: @escaping (T) -> ()) {
        let _ = Holder.shared
        self.performSegue(withIdentifier: storyboardId, sender: SegueConfigurationHolder(closure: { controller in
            if let casted = controller as? T {
                configuration(casted)
            } else if let navController = controller as? UINavigationController,
                let casted = navController.viewControllers.first as? T {
                configuration(casted)
            }
        }))
    }
    
    final func ts_closeController(animated: Bool) {
        if let navController = self.parent as? UINavigationController, navController.viewControllers.count > 1 {
            navController.popViewController(animated: true)
        } else if let _ = self.presentingViewController {
            self.dismiss(animated: animated, completion: nil)
        } else if self.view.superview != nil {
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
}
