//
//  SpotSpotInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SpotInteractor: NSObject, SpotInteractorInput {

    weak var output: SpotInteractorOutput!
    weak var session: TwitterSession!
    weak var homeTimelineModel: HomeTimelineModel!
    weak var imagesService: ImagesService!
    weak var settingsSvc: SettignsService!
    
    let prefetchRepeatInterval = 60.0
    var prefetchInProgress = false
    var pendingForwardRequest = false
    var prefetchingIsOn = true
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        super.init()
    }
    
    func requestIfNeedToShowAvatars() {
        output.avatarsDisplay(required: self.settingsSvc.shouldDisplayUserAvatarsOnSpot)
    }
    
    func sessionCloseRequested() {
        session.closeSession()
    }
    
    func requestDTOForItem(item: SpotTweetItem) {
        for dto in homeTimelineModel.homeLineTweets {
            if dto.id == item.id {
                output.dtoFoundForItem(item, dto: dto)
                return
            }
        }
        output.dtoFoundForItem(item, dto: nil)
    }
    
    func loadForwardRequested() {
        if prefetchInProgress {
            pendingForwardRequest = true
            return
        }
        
        log.verbose("Load forward")
        disablePreviousPrefetchrequest()
        homeTimelineModel.loadForward({ (dtos) in
            let result = self.viewModelItemsFromDTOs(dtos)
            self.output.forwardItemsLoaded(result)
            self.schedulePrefetchIfNeeded()
        }) { (error) in
            self.output.forwardItemsLoaded([])
            log.debug("Error while loading forward")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    func loadBackwardRequested() {
        log.verbose("Load backward")
        homeTimelineModel.loadBackward({ (dtos) in
            let result = self.viewModelItemsFromDTOs(dtos)
            if result.count == 0 {
                self.output.handleNoMoreItemsAtBackward()
            } else {
                self.output.backwardItemsLoaded(result)
            }
        }) { (error) in
            self.output.backwardItemsLoaded([])
            log.debug("Error while loading backward")
        }
    }
    
    func setPrefetchingEnabled(enabled: Bool) {
        prefetchingIsOn = enabled
        if enabled {
            self.schedulePrefetchIfNeeded()
        } else {
            disablePreviousPrefetchrequest()
        }
    }
    
    func prefetchItems() {
        log.verbose("Prefetching")
        prefetchInProgress = true
        homeTimelineModel.loadForward({ (dtos) in
            self.prefetchInProgress = false
            let result = self.viewModelItemsFromDTOs(dtos)
            if self.pendingForwardRequest {
                self.pendingForwardRequest = false
                self.output.forwardItemsLoaded(result)
            } else {
                self.output.prefetchedItemsAvailable(result)
            }
            
            self.schedulePrefetchIfNeeded()
        }) { (error) in
            self.prefetchInProgress = false
            log.debug("Error while prefetching")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    private func viewModelItemsFromDTOs(dtos: [TweetDTO]) -> [SpotTweetItem] {
        var result: [SpotTweetItem] = []
        for dto in dtos {
            let item = SpotTweetItem(id: dto.id,
                                     formattedPostDate: self.dateFormatter.stringFromDate(dto.creationDate),
                                     text: dto.text,
                                     userName: dto.userName,
                                     screenName: dto.screenName)
            self.promiseImageLoad(item, urlString: dto.avatarUrlStr)
            result.append(item)
        }
        return result
    }
    
    private func promiseImageLoad(item: SpotTweetItem, urlString: String) {
        let promise = self.imagesService.imagePromiseForUrl(urlString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger"))
        promise.notifyCall = { (img, error) in
            if let image = img {
                item.avatar = image
                if let callback = item.avatarRetrievedCallback {
                    callback()
                }
            }
        }
    }
    
    private func schedulePrefetchIfNeeded() {
        if prefetchingIsOn {
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SpotInteractor.prefetchItems), object: nil)
            self.performSelector(#selector(SpotInteractor.prefetchItems), withObject: nil, afterDelay: self.prefetchRepeatInterval)
        }
    }
    
    private func disablePreviousPrefetchrequest() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SpotInteractor.prefetchItems), object: nil)
    }
}
