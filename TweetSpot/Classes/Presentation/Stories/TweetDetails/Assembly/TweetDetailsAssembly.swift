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

    @objc dynamic func viewTweetDetailsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TweetDetailsViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterTweetDetailsModule())
            definition.injectProperty("moduleInput", with: self.presenterTweetDetailsModule())          
        }
    }

    @objc dynamic func interactorTweetDetailsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TweetDetailsInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterTweetDetailsModule())
            definition.injectProperty("imagesService", with: self.coreServices.imagesService())
            
        }
    }

    @objc dynamic func presenterTweetDetailsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TweetDetailsPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewTweetDetailsModule())
            definition.injectProperty("interactor", with: self.interactorTweetDetailsModule())          
            definition.injectProperty("router", with: self.routerTweetDetailsModule())      
        }
    }

    @objc dynamic func routerTweetDetailsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TweetDetailsRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewTweetDetailsModule())       
        }
    }
}
