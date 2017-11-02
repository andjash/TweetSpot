//
//  NavigationRootNavigationRootRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import ViperMcFlurry

class NavigationRootRouter: NSObject, NavigationRootRouterInput {

	weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol!
    
    func routeToLogin() {
        transitionHandler.openModule?(usingSegue: "RootToLoginSegue").thenChain { (input) -> RamblerViperModuleOutput! in
            return nil
        }
    }
    
    func routeToSpot() {
        transitionHandler.openModule?(usingSegue: "RootToSpotSegue").thenChain { (input) -> RamblerViperModuleOutput! in
            return nil
        }
    }

}
