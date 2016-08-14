//
//  SettingsSettingsRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import ViperMcFlurry

class SettingsRouter: NSObject, SettingsRouterInput {

	weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol!

    func closeModule() {
        transitionHandler.closeCurrentModule?(true)
    }
    
}
