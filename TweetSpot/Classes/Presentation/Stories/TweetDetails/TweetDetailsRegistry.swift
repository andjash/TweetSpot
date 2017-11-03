//
//  TweetDetailsRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

final class TweetDetailsRegistry: LazyRegistry {
    
    override init() {
        super.init()
        
        registerStoryboardInjection(TweetDetailsViewController.self, storyboardId: "TweetDetailsViewController") { controller in
            self.initiateLazyRegistration()
            controller.output = self.resolve() as TweetDetailsPresenter
        }
    }
    
    // MARK: Private
    
    override func lazyRegistration() {
        let businessLogicRegistry = ModulesRegistry.shared.resolve() as BusinessLogicRegistry
        
        register(lifetime: .objectGraph, initCall: { TweetDetailsPresenter() }) { component in
            component.view = self.resolve() as TweetDetailsViewController
            component.interactor = self.resolve() as TweetDetailsInteractor
        }
        
        register(lifetime: .objectGraph, initCall: { TweetDetailsInteractor() }) { component in
            component.output = self.resolve() as TweetDetailsPresenter
            component.imagesService = businessLogicRegistry.resolve() as ImagesService
        }
    }
}
