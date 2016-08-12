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
        transitionHandler.openModuleUsingSegue?("RootToLoginSegue").thenChainUsingBlock { (input) -> RamblerViperModuleOutput! in
            return nil
        }
    }

}
