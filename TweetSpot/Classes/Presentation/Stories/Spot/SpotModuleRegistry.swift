//
//  SpotModuleRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

final class SpotModuleRegistry: LazyRegistry {
    
    override init() {
        super.init()
        
        registerStoryboardInjection(SpotViewController.self, storyboardId: "SpotViewController") { controller in
            self.initiateLazyRegistration()
            controller.output = self.resolve() as SpotPresenter
            controller.tableDataManager = SpotTableDataManagerImpl()
        }
    }
    
    // MARK: Private
    
    override func lazyRegistration() {
        let businessLogicRegistry = ModulesRegistry.shared.resolve() as BusinessLogicRegistry
        let coreRegistry = ModulesRegistry.shared.resolve() as CoreServicesRegistry
        
        register(lifetime: .objectGraph, initCall: { SpotPresenter() }) { component in
            component.view = self.resolve() as SpotViewController
            component.interactor = self.resolve() as SpotInteractor
            component.router = self.resolve() as SpotRouter
        }
        
        register(lifetime: .objectGraph, initCall: { SpotInteractor() }) { component in
            component.output = self.resolve() as SpotPresenter
            component.session = businessLogicRegistry.resolve() as TwitterSession
            component.settingsSvc = businessLogicRegistry.resolve() as SettingsService
            component.imagesService = coreRegistry.resolve() as ImagesService
            component.homeTimelineModel = businessLogicRegistry.resolve() as HomeTimelineModel
            component.mappingQueue = DispatchQueue(label: "SpotInteractor.mappingQueue", attributes: DispatchQueue.Attributes.concurrent)
        }
        
        register(lifetime: .objectGraph, initCall: { SpotRouter() }) { component in
            component.sourceController = self.resolve() as SpotViewController
        }
    }
}
