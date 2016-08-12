//
//  LoginLoginAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import RamblerTyphoonUtils
import Typhoon

class LoginAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    weak var coreServices: CoreServicesAssembly!

    dynamic func viewLoginModule() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterLoginModule())
            definition.injectProperty("moduleInput", with: self.presenterLoginModule())          
        }
    }

    dynamic func interactorLoginModule() -> AnyObject {
        return TyphoonDefinition.withClass(LoginInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterLoginModule())       
            definition.injectProperty("socAccountsService", with: self.coreServices.socialAccountsService())
            definition.injectProperty("twitterSession", with: self.coreServices.twitterSessionService())
        }
    }

    dynamic func presenterLoginModule() -> AnyObject {
        return TyphoonDefinition.withClass(LoginPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewLoginModule())
            definition.injectProperty("interactor", with: self.interactorLoginModule())          
            definition.injectProperty("router", with: self.routerLoginModule())      
        }
    }

    dynamic func routerLoginModule() -> AnyObject {
        return TyphoonDefinition.withClass(LoginRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewLoginModule())       
        }
    }
}