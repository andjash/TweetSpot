//
//  SettingsSettingsAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import RamblerTyphoonUtils
import Typhoon

class SettingsAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    var businessLogic: BusinesLogicAssembly!

    @objc dynamic func viewSettingsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SettingsViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterSettingsModule())
            definition.injectProperty("moduleInput", with: self.presenterSettingsModule())          
        }
    }

    @objc dynamic func interactorSettingsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SettingsInteractor.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithSettingsSvc:")) {
                (initializer) in
                
                initializer!.injectParameter(with: self.businessLogic.settingsService())
            }
            definition.injectProperty("output", with: self.presenterSettingsModule())
        }                              
    }

    @objc dynamic func presenterSettingsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SettingsPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewSettingsModule())
            definition.injectProperty("interactor", with: self.interactorSettingsModule())          
            definition.injectProperty("router", with: self.routerSettingsModule())      
        }
    }

    @objc dynamic func routerSettingsModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SettingsRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewSettingsModule())       
        }
    }
}
