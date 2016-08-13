//
//  SpotSpotPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SpotPresenter: NSObject, SpotModuleInput  {

    weak var view: SpotViewInput!
    var interactor: SpotInteractorInput!
    var router: SpotRouterInput!

    func viewIsReady() {

    }
}


extension SpotPresenter : SpotViewOutput {
    
    func quitRequested() {
        interactor.sessionCloseRequested()
        router.closeModule()
    }
    
    func settingsRequested() {
        interactor.loadForwardRequested()
    }
    
    func loadAboveRequsted() {
        interactor.loadForwardRequested()
    }
    func loadBelowRequested() {
        interactor.loadBackwardRequested()
    }
}


extension SpotPresenter : SpotInteractorOutput {
    
    func forwardItemsLoaded(items: [SpotTweetItem]) {
        view.displayItemsAbove(items)
    }
    
    func backwardItemsLoaded(items: [SpotTweetItem]) {
        view.displayItemsBelow(items)
    }
        
    func forwardProgressUpdated(enabled enabled: Bool) {
        view.showForwardLoading(enabled: enabled)
    }
    
    func backwardProgressUpdated(enabled enabled: Bool) {
        view.showBackwardLoading(enabled: enabled)
    }
    
}

  