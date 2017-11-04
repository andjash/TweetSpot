//
//  SpotSpotPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class SpotPresenter  {

    final weak var view: SpotViewController!
    final var interactor: SpotInteractor!
    final var router: SpotRouter!
    final var hasItemsAtPast = true
    final var retrievingCahce = false
    final var prefetchedItems: [SpotTweetItem] = []

    // MARK: - View output
    
    final func viewIsReady() {
        retrievingCahce = true
        view.setInfiniteScrollingEnabled(false)
        interactor.requestCachedItems { (items) in
            if (items?.count ?? 0) > 0 {
                self.view.setInfiniteScrollingEnabled(true)
                self.view.displayItemsAbove(items!)
            }
            self.view.showAboveLoading(enabled: true)
            self.interactor.loadForwardRequested()
            self.retrievingCahce = false
        }
    }
    
    final func viewIsAboutToAppear() {
        view.updateCellsWithAvatars(displayRequired:interactor.requestIfNeedToShowAvatars())
        interactor.setPrefetchingEnabled(true)
    }
    
    final func viewIsAboutToDisappear() {
        interactor.setPrefetchingEnabled(false)
    }
    
    final func quitRequested() {
        interactor.sessionCloseRequested()
        router.closeModule()
    }
    
    final func settingsRequested() {
        router.routeToSettingsModule()
    }
    
    final func loadAboveRequested() {
        if !retrievingCahce {
            interactor.loadForwardRequested()
        }
    }
    
    final func loadBelowRequested() {
        interactor.loadBackwardRequested()
    }
    
    final func didSelectItem(_ item: SpotTweetItem) {
        interactor.requestDTOForItem(item)
    }
    
    final func showMoreItemsRequested() {
        interactor.loadForwardRequested()
    }
    
    final func avatarsLoadRequestedForItems(_ items: [SpotTweetItem]) {
        interactor.requestImagesForItems(items)
    }
    
    // MARK: - Interactor output

    final func prefetchedItemsAvailable(_ prefetchedItems: [SpotTweetItem]) {
        self.prefetchedItems += prefetchedItems
        view.showMoreItemsAvailable()
    }
    
    final func dtoFoundForItem(_ item: SpotTweetItem, dto: TweetDTO?) {
        if let udto = dto {
            router.routeToTweetDetails(udto)
        }
    }
    
    final func forwardItemsLoaded(_ items: [SpotTweetItem]) {
        if items.count > 0 && hasItemsAtPast {
            view.setInfiniteScrollingEnabled(true)
        }
        view.displayItemsAbove(items + prefetchedItems)
        prefetchedItems.removeAll()
    }
    
    final func backwardItemsLoaded(_ items: [SpotTweetItem]) {
        view.displayItemsBelow(items)
    }
    
    final func handleNoMoreItemsAtBackward() {
        hasItemsAtPast = false
        view.setInfiniteScrollingEnabled(false)
    }
}
