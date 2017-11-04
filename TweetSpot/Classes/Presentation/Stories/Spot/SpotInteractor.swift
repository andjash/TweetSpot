//
//  SpotSpotInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

// NSObject inheritance for debounce
final class SpotInteractor: NSObject {

    final weak var output: SpotPresenter!
    final weak var session: TwitterSession!
    final weak var homeTimelineModel: HomeTimelineModel!
    final weak var imagesService: ImagesService!
    final weak var settingsSvc: SettingsService!
    final var mappingQueue: DispatchQueue!
    
    final let prefetchRepeatInterval = 60.0
    final var prefetchInProgress = false
    final var pendingForwardRequest = false
    final var prefetchingIsOn = true
    
    final let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.ts_configureAsAppCommonFormatter()
        super.init()
    }
    
    // MARK: - Input
    
    final func requestCachedItems(_ completion: @escaping ([SpotTweetItem]?) -> ()) {
        let dtos = homeTimelineModel.homeLineTweets
        mappingQueue.async { 
            let result = self.viewModelItemsFromDTOs(dtos)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    final func requestImagesForItems(_ items: [SpotTweetItem]) {
        let dtos = self.homeTimelineModel.homeLineTweets
        mappingQueue.async {
            var dict : [String : String] = [:]
            for dto in dtos {
                dict[dto.id] = dto.avatarUrlStr
            }
            for item in items {
                if let url = dict[item.id] {
                    self.promiseImageLoad(item, urlString: url)
                }
            }
        }
    }
    
    final func requestIfNeedToShowAvatars() -> Bool {
        return settingsSvc.shouldDisplayUserAvatarsOnSpot
    }
    
    final func sessionCloseRequested() {
        session.closeSession()
    }
    
    final func requestDTOForItem(_ item: SpotTweetItem) {
        for dto in homeTimelineModel.homeLineTweets {
            if dto.id == item.id {
                output.dtoFoundForItem(item, dto: dto)
                return
            }
        }
        output.dtoFoundForItem(item, dto: nil)
    }
    
    final func loadForwardRequested() {
        if prefetchInProgress {
            pendingForwardRequest = true
            return
        }
        
        log.verbose("Load forward")
        disablePreviousPrefetchrequest()
        homeTimelineModel.loadForward({ (dtos) in
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async {
                    self.output.forwardItemsLoaded(result)
                    self.schedulePrefetchIfNeeded()
                }
            }
        }) { (error) in
            self.output.forwardItemsLoaded([])
            log.debug("Error while loading forward")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    final func loadBackwardRequested() {
        log.verbose("Load backward")
        homeTimelineModel.loadBackward({ (dtos) in
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async {
                    if result.count == 0 {
                        self.output.handleNoMoreItemsAtBackward()
                    } else {
                        self.output.backwardItemsLoaded(result)
                    }
                }
            }
        }) { (error) in
            self.output.backwardItemsLoaded([])
            log.debug("Error while loading backward")
        }
    }
    
    final func setPrefetchingEnabled(_ enabled: Bool) {
        prefetchingIsOn = enabled
        if enabled {
            schedulePrefetchIfNeeded()
        } else {
            disablePreviousPrefetchrequest()
        }
    }
    
    // MARK: - Private
    
    @objc final private func prefetchItems() {
        log.verbose("Prefetching")
        prefetchInProgress = true
        homeTimelineModel.loadForward({ (dtos) in
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async {
                    self.prefetchInProgress = false
                    if self.pendingForwardRequest {
                        self.pendingForwardRequest = false
                        self.output.forwardItemsLoaded(result)
                    } else {
                        if result.count > 0 {
                            self.output.prefetchedItemsAvailable(result)
                        }
                    }
                    self.schedulePrefetchIfNeeded()
                }
            }
        }) { (error) in
            self.prefetchInProgress = false
            log.debug("Error while prefetching")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    final private func viewModelItemsFromDTOs(_ dtos: [TweetDTO]) -> [SpotTweetItem] {
        var result: [SpotTweetItem] = []
        for dto in dtos {
            let item = SpotTweetItem(id: dto.id,
                                     formattedPostDate: dateFormatter.string(from: dto.creationDate as Date),
                                     text: dto.text,
                                     userName: dto.userName,
                                     screenName: dto.screenName)
            self.promiseImageLoad(item, urlString: dto.avatarUrlStr)
            result.append(item)
        }
        return result
    }

    final private func promiseImageLoad(_ item: SpotTweetItem, urlString: String) {
        guard settingsSvc.shouldDisplayUserAvatarsOnSpot else { return }
        
        let promise = imagesService.imagePromise(with: urlString.replacingOccurrences(of: "_normal", with: "_bigger"))
        promise.notifyCall = { (img, error) in
            if let image = img {
                item.avatar = image
                if let callback = item.avatarRetrievedCallback {
                    callback()
                }
            }
        }
    }
    
    
    final private func schedulePrefetchIfNeeded() {
        if prefetchingIsOn {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SpotInteractor.prefetchItems), object: nil)
            perform(#selector(prefetchItems), with: nil, afterDelay: prefetchRepeatInterval)
        }
    }
    
    final private func disablePreviousPrefetchrequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(prefetchItems), object: nil)
    }
}
