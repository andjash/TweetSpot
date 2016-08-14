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
    var hasItemsAtPast = true
    var prefetchedItems: [SpotTweetItem] = []
}


extension SpotPresenter : SpotViewOutput {
    
    func viewIsReady() {
        view.setInfiniteScrollingEnabled(false)
        view.showAboveLoading(enabled: true)
        interactor.loadForwardRequested()
    }
    
    func viewIsAboutToAppear() {
        interactor.requestIfNeedToShowAvatars()
        interactor.setPrefetchingEnabled(true)
    }
    
    func viewIsAboutToDisappear() {
        interactor.setPrefetchingEnabled(false)        
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
    
    func showMoreItemsRequested() {
        interactor.loadForwardRequested()
    }
}


extension SpotPresenter : SpotInteractorOutput {
    
    func prefetchedItemsAvailable(prefetchedItems: [SpotTweetItem]) {
        self.prefetchedItems += prefetchedItems
        view.showMoreItemsAvailable()
    }
    
    func dtoFoundForItem(item: SpotTweetItem, dto: AnyObject?) {
        if let udto = dto {
            router.routeToTweetDetails(udto)
        }
    }
    
    func avatarsDisplay(required required: Bool) {
        view.updateCellWithAvatars(displayRequired:required)
    }
    
    func forwardItemsLoaded(items: [SpotTweetItem]) {
        if items.count > 0 && hasItemsAtPast {
            view.setInfiniteScrollingEnabled(true)
        }
        view.displayItemsAbove(items + prefetchedItems)
        prefetchedItems.removeAll()
    }
    
    func backwardItemsLoaded(items: [SpotTweetItem]) {
        view.displayItemsBelow(items)
    }
    
    func handleNoMoreItemsAtBackward() {
        hasItemsAtPast = false
        view.setInfiniteScrollingEnabled(false)
    }
    
}

  