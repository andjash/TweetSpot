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

   
}


extension SpotPresenter : SpotViewOutput {
    
    func viewIsReady() {
        view.showAboveLoading(enabled: true)
        interactor.loadForwardRequested()
    }
    
    func viewIsAboutToAppear() {
        interactor.requestIfNeedToShowAvatars()
    }
    
    func quitRequested() {
        interactor.sessionCloseRequested()
        router.closeModule()
    }
    
    func settingsRequested() {
        router.routeToSettingsModule()
    }
    
    func loadAboveRequested() {
        interactor.loadForwardRequested()
    }
    
    func loadBelowRequested() {
        interactor.loadBackwardRequested()
    }
    
    func didSelectItem(item: SpotTweetItem) {
        interactor.requestDTOForItem(item)
    }
}


extension SpotPresenter : SpotInteractorOutput {
    
    func dtoFoundForItem(item: SpotTweetItem, dto: AnyObject?) {
        if let udto = dto {
            router.routeToTweetDetails(udto)
        }
    }
    
    func avatarsDisplay(required required: Bool) {
        view.updateCellWithAvatars(displayRequired:required)
    }
    
    func forwardItemsLoaded(items: [SpotTweetItem]) {
        view.displayItemsAbove(items)
    }
    
    func backwardItemsLoaded(items: [SpotTweetItem]) {
        view.displayItemsBelow(items)
    }
        
    func forwardProgressUpdated(enabled enabled: Bool) {
        view.showAboveLoading(enabled: enabled)
    }
    
    func backwardProgressUpdated(enabled enabled: Bool) {
        view.showBelowLoading(enabled: enabled)
    }
    
}

  