//
//  LoginModuleRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

final class LoginModuleRegistry: LazyRegistry {
    
    override init() {
        super.init()
        
        registerStoryboardInjection(LoginViewController.self, storyboardId: "LoginViewController") { controller in
            self.initiateLazyRegistration()
            controller.output = self.resolve() as LoginPresenter
        }
    }
    
    // MARK: Private
    
    override func lazyRegistration() {
        let businessLogicRegistry = ModulesRegistry.shared.resolve() as BusinessLogicRegistry
        let coreRegistry = ModulesRegistry.shared.resolve() as CoreServicesRegistry
        
        register(lifetime: .objectGraph, initCall: { LoginPresenter() }) { component in
            component.view = self.resolve() as LoginViewController
            component.interactor = self.resolve() as LoginInteractor
            component.router = self.resolve() as LoginRouter
        }
        
        register(lifetime: .objectGraph, initCall: { LoginInteractor() }) { component in
            component.output = self.resolve() as LoginPresenter
            component.twitterSession = businessLogicRegistry.resolve() as TwitterSession
            component.socAccountsService = coreRegistry.resolve() as SocialAccountsService
        }
        
        register(lifetime: .objectGraph, initCall: { LoginRouter() }) { component in
            component.sourceController = self.resolve() as LoginViewController
        }
    }
    
}
