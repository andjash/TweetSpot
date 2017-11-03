//
//  NavigationRootNavigationRootRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import ViperMcFlurry

class NavigationRootRouter: NSObject {

	weak var sourceController: UIViewController!
    
    // MARK: - Input
    
    final func routeToLogin() {
        sourceController.performSegue("RootToLoginSegue")
    }
    
    final func routeToSpot() {
        sourceController.performSegue("RootToSpotSegue")
    }

}
