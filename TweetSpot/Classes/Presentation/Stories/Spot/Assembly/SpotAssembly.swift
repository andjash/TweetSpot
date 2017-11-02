//
//  SpotSpotAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import RamblerTyphoonUtils
import Typhoon

class SpotAssembly: TyphoonAssembly, RamblerInitialAssembly {

    weak var businessLogicAssembly: BusinesLogicAssembly!
    weak var coreServices: CoreServicesAssembly!
    
    @objc dynamic func viewSpotModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SpotViewController.self) {
            (definition) in
            definition.injectProperty("output", with: self.presenterSpotModule())
            definition.injectProperty("moduleInput", with: self.presenterSpotModule())
            definition.injectProperty("tableDataManager", with: self.spotTableDataManger())
        }
    }

    @objc dynamic func interactorSpotModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SpotInteractor.self) {
            (definition) in
            
            definition.injectProperty("output", with: self.presenterSpotModule())
            definition.injectProperty("session", with: self.businessLogicAssembly.twitterSessionService())
            definition.injectProperty("homeTimelineModel", with: self.businessLogicAssembly.homeTimelineModel())
            definition.injectProperty("imagesService", with: self.coreServices.imagesService())            
            definition.injectProperty("settingsSvc", with: self.businessLogicAssembly.settingsService())
            definition.injectProperty("mappingQueue", with: DispatchQueue(label: "TSpotInteractor.mappingQueue", attributes: []))
            
            
        }
    }

    @objc dynamic func presenterSpotModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SpotPresenter.self) {
            (definition) in
            definition.injectProperty("view", with: self.viewSpotModule())
            definition.injectProperty("interactor", with: self.interactorSpotModule())          
            definition.injectProperty("router", with: self.routerSpotModule())      
        }
    }

    @objc dynamic func routerSpotModule() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SpotRouter.self) {
            (definition) in
            definition.injectProperty("transitionHandler", with: self.viewSpotModule())       
        }
    }
    
    @objc dynamic func spotTableDataManger() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SpotTableDataManagerImpl.self) {
            (definition) in
        }
    }
}
