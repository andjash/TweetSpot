//
//  NavigationRootNavigationRootRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class NavigationRootRouter {

	final weak var sourceController: UIViewController!
    
    // MARK: - Input
    
    final func routeToLogin() {
        sourceController.ts_openController(LoginViewController.self, storyboardId: "RootToLoginSegue") { (c) in }
    }
    
    final func routeToSpot() {
        sourceController.ts_openController(SpotViewController.self, storyboardId: "RootToSpotSegue") { (c) in }
    }

}
