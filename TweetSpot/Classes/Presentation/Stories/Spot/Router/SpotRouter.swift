//
//  SpotSpotRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import ViperMcFlurry

class SpotRouter: NSObject, SpotRouterInput {

	weak var transitionHandler: RamblerViperModuleTransitionHandlerProtocol!
    
    func closeModule() {
        transitionHandler.closeCurrentModule?(true)
    }
    
    func routeToSettingsModule() {
        transitionHandler.openModuleUsingSegue?("SpotToSettingsSegue").thenChainUsingBlock { (input) -> RamblerViperModuleOutput! in
            return nil
        }
    }
    
    func routeToTweetDetails(withDTO: AnyObject) {
        transitionHandler.openModuleUsingSegue?("SpotToTweetDetailsSegue").thenChainUsingBlock { (input) -> RamblerViperModuleOutput! in
            if let tweetModuleInput = input as? TweetDetailsModuleInput {
                tweetModuleInput.configureWithDTO(withDTO)
            }
            return nil
        }
    }

}
