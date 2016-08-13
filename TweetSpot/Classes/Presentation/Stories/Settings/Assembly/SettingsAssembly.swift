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

    dynamic func viewSettingsModule() -> AnyObject {
        return TyphoonDefinition.withClass(SettingsViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterSettingsModule())
            definition.injectProperty("moduleInput", with: self.presenterSettingsModule())          
        }
    }

    dynamic func interactorSettingsModule() -> AnyObject {
        return TyphoonDefinition.withClass(SettingsInteractor.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterSettingsModule())       
        }
    }

    dynamic func presenterSettingsModule() -> AnyObject {
        return TyphoonDefinition.withClass(SettingsPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewSettingsModule())
            definition.injectProperty("interactor", with: self.interactorSettingsModule())          
            definition.injectProperty("router", with: self.routerSettingsModule())      
        }
    }

    dynamic func routerSettingsModule() -> AnyObject {
        return TyphoonDefinition.withClass(SettingsRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewSettingsModule())       
        }
    }
}