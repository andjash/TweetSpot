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
    weak var businessLogicAssembly: BusinesLogicAssembly!
    
    @objc dynamic func viewLoginModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(LoginViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterLoginModule())
            definition.injectProperty("moduleInput", with: self.presenterLoginModule())          
        }
    }

    @objc dynamic func interactorLoginModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(LoginInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterLoginModule())       
            definition.injectProperty("socAccountsService", with: self.coreServices.socialAccountsService())
            definition.injectProperty("twitterSession", with: self.businessLogicAssembly.twitterSessionService())
        }
    }

    @objc dynamic func presenterLoginModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(LoginPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewLoginModule())
            definition.injectProperty("interactor", with: self.interactorLoginModule())          
            definition.injectProperty("router", with: self.routerLoginModule())      
        }
    }

    @objc dynamic func routerLoginModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(LoginRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewLoginModule())       
        }
    }
}
