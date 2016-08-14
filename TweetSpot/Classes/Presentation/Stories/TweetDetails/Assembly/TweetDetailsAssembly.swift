//
//  TweetDetailsTweetDetailsAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import RamblerTyphoonUtils
import Typhoon

class TweetDetailsAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    var coreServices: CoreServicesAssembly!

    dynamic func viewTweetDetailsModule() -> AnyObject {
        return TyphoonDefinition.withClass(TweetDetailsViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterTweetDetailsModule())
            definition.injectProperty("moduleInput", with: self.presenterTweetDetailsModule())          
        }
    }

    dynamic func interactorTweetDetailsModule() -> AnyObject {
        return TyphoonDefinition.withClass(TweetDetailsInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterTweetDetailsModule())
            definition.injectProperty("imagesService", with: self.coreServices.imagesService())
            
        }
    }

    dynamic func presenterTweetDetailsModule() -> AnyObject {
        return TyphoonDefinition.withClass(TweetDetailsPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewTweetDetailsModule())
            definition.injectProperty("interactor", with: self.interactorTweetDetailsModule())          
            definition.injectProperty("router", with: self.routerTweetDetailsModule())      
        }
    }

    dynamic func routerTweetDetailsModule() -> AnyObject {
        return TyphoonDefinition.withClass(TweetDetailsRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewTweetDetailsModule())       
        }
    }
}