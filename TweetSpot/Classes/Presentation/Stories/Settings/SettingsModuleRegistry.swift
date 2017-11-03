//
//  SettingsModuleRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

final class SettingsModuleRegistry: LazyRegistry {
    
    override init() {
        super.init()
        
        registerStoryboardInjection(SettingsViewController.self, storyboardId: "SettingsViewController") { controller in
            self.initiateLazyRegistration()
            controller.output = self.resolve() as SettingsPresenter
        }
    }
    
    // MARK: Private
    
    override func lazyRegistration() {
        let businessLogicRegistry = ModulesRegistry.shared.resolve() as BusinessLogicRegistry
        
        register(lifetime: .objectGraph, initCall: { SettingsPresenter() }) { component in
            component.view = self.resolve() as SettingsViewController
            component.interactor = self.resolve() as SettingsInteractor
            component.router = self.resolve() as SettingsRouter
        }
        
        register(lifetime: .objectGraph, initCall: { SettingsInteractor() }) { component in
            component.output = self.resolve() as SettingsPresenter
            component.settingsSvc = businessLogicRegistry.resolve() as SettingsService
        }
        
        register(lifetime: .objectGraph, initCall: { SettingsRouter() }) { component in
            component.sourceController = self.resolve() as SettingsViewController
        }
    }
}
