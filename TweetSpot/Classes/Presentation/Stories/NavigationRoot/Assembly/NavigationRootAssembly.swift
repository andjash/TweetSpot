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
    
    weak var businessLogicAssembly: BusinesLogicAssembly!
   
    @objc dynamic func viewNavigationRootModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(NavigationRootViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterNavigationRootModule())
            definition.injectProperty("moduleInput", with: self.presenterNavigationRootModule())          
        }
    }

    @objc dynamic func interactorNavigationRootModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(NavigationRootInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterNavigationRootModule())
            definition.injectProperty("session", with: self.businessLogicAssembly.twitterSessionService())
        }
    }

    @objc dynamic func presenterNavigationRootModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(NavigationRootPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewNavigationRootModule())
            definition.injectProperty("interactor", with: self.interactorNavigationRootModule())          
            definition.injectProperty("router", with: self.routerNavigationRootModule())      
        }
    }

    @objc dynamic func routerNavigationRootModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(NavigationRootRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewNavigationRootModule())       
        }
    }
}
