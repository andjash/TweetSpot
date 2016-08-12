//
//  NavigationRootNavigationRootAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import RamblerTyphoonUtils
import Typhoon

class NavigationRootAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    weak var coreServices: CoreServicesAssembly!

    dynamic func viewNavigationRootModule() -> AnyObject {
        return TyphoonDefinition.withClass(NavigationRootViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterNavigationRootModule())
            definition.injectProperty("moduleInput", with: self.presenterNavigationRootModule())          
        }
    }

    dynamic func interactorNavigationRootModule() -> AnyObject {
        return TyphoonDefinition.withClass(NavigationRootInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterNavigationRootModule())
            definition.injectProperty("session", with: self.coreServices.twitterSessionService())
        }
    }

    dynamic func presenterNavigationRootModule() -> AnyObject {
        return TyphoonDefinition.withClass(NavigationRootPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewNavigationRootModule())
            definition.injectProperty("interactor", with: self.interactorNavigationRootModule())          
            definition.injectProperty("router", with: self.routerNavigationRootModule())      
        }
    }

    dynamic func routerNavigationRootModule() -> AnyObject {
        return TyphoonDefinition.withClass(NavigationRootRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewNavigationRootModule())       
        }
    }
}