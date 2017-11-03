//
//  NavigationRootRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

final class NavigationRootRegistry: LazyRegistry {
    
    override init() {
        super.init()
        
        registerStoryboardInjection(NavigationRootViewController.self, storyboardId: "NavigationRootViewController") { controller in
            self.initiateLazyRegistration()
            controller.output = self.resolve() as NavigationRootPresenter
        }
    }
    
    // MARK: Private
    
    override func lazyRegistration() {
        let businessLogicRegistry = ModulesRegistry.shared.resolve() as BusinessLogicRegistry
        
        register(lifetime: .objectGraph, initCall: { NavigationRootPresenter() }) { component in
            component.view = self.resolve() as NavigationRootViewController
            component.interactor = self.resolve() as NavigationRootInteractor
            component.router = self.resolve() as NavigationRootRouter
        }
        
        register(lifetime: .objectGraph, initCall: { NavigationRootInteractor() }) { component in
            component.output = self.resolve() as NavigationRootPresenter
            component.session = businessLogicRegistry.resolve() as TwitterSession
        }
        
        register(lifetime: .objectGraph, initCall: { NavigationRootRouter() }) { component in
            component.sourceController = self.resolve() as NavigationRootViewController
        }
    }
}
