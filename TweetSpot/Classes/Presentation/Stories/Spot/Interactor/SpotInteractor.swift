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
    var mappingQueue: DispatchQueue!
    
    let prefetchRepeatInterval = 60.0
    var prefetchInProgress = false
    var pendingForwardRequest = false
    var prefetchingIsOn = true
    
    let dateFormatter: DateFormatter
    
    override init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.ts_configureAsAppCommonFormatter()
        super.init()
    }
    
    func requestCachedItems(_ completion: @escaping ([SpotTweetItem]?) -> ()) {
        let dtos = self.homeTimelineModel.homeLineTweets
        mappingQueue.async { 
            let result = self.viewModelItemsFromDTOs(dtos)
            DispatchQueue.main.async(execute: {
                completion(result)
            })
        }
    }
    
    func requestImagesForItems(_ items: [SpotTweetItem]) {
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
    
    func requestIfNeedToShowAvatars() -> Bool {
        return self.settingsSvc.shouldDisplayUserAvatarsOnSpot
    }
    
    func sessionCloseRequested() {
        session.closeSession()
    }
    
    func requestDTOForItem(_ item: SpotTweetItem) {
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
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async(execute: {
                    self.output.forwardItemsLoaded(result)
                    self.schedulePrefetchIfNeeded()
                })
            }
        }) { (error) in
            self.output.forwardItemsLoaded([])
            log.debug("Error while loading forward")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    func loadBackwardRequested() {
        log.verbose("Load backward")
        homeTimelineModel.loadBackward({ (dtos) in
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async(execute: {
                    if result.count == 0 {
                        self.output.handleNoMoreItemsAtBackward()
                    } else {
                        self.output.backwardItemsLoaded(result)
                    }
                })
            }
        }) { (error) in
            self.output.backwardItemsLoaded([])
            log.debug("Error while loading backward")
        }
    }
    
    func setPrefetchingEnabled(_ enabled: Bool) {
        prefetchingIsOn = enabled
        if enabled {
            self.schedulePrefetchIfNeeded()
        } else {
            disablePreviousPrefetchrequest()
        }
    }
    
    @objc func prefetchItems() {
        log.verbose("Prefetching")
        prefetchInProgress = true
        homeTimelineModel.loadForward({ (dtos) in
            self.mappingQueue.async {
                let result = self.viewModelItemsFromDTOs(dtos)
                DispatchQueue.main.async(execute: {
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
                })
            }
        }) { (error) in
            self.prefetchInProgress = false
            log.debug("Error while prefetching")
            self.schedulePrefetchIfNeeded()
        }
    }
    
    fileprivate func viewModelItemsFromDTOs(_ dtos: [TweetDTO]) -> [SpotTweetItem] {
        var result: [SpotTweetItem] = []
        for dto in dtos {
            let item = SpotTweetItem(id: dto.id,
                                     formattedPostDate: self.dateFormatter.string(from: dto.creationDate as Date),
                                     text: dto.text,
                                     userName: dto.userName,
                                     screenName: dto.screenName)
            self.promiseImageLoad(item, urlString: dto.avatarUrlStr)
            result.append(item)
        }
        return result
    }

    fileprivate func promiseImageLoad(_ item: SpotTweetItem, urlString: String) {
        if !self.settingsSvc.shouldDisplayUserAvatarsOnSpot {
            return
        }
        let promise = imagesService.imagePromiseForUrl(urlString.replacingOccurrences(of: "_normal", with: "_bigger"))
        promise.notifyCall = { (img, error) in
            if let image = img {
                item.avatar = image
                if let callback = item.avatarRetrievedCallback {
                    callback()
                }
            }
        }
    }
    
    
    fileprivate func schedulePrefetchIfNeeded() {
        if prefetchingIsOn {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SpotInteractor.prefetchItems), object: nil)
            self.perform(#selector(SpotInteractor.prefetchItems), with: nil, afterDelay: self.prefetchRepeatInterval)
        }
    }
    
    fileprivate func disablePreviousPrefetchrequest() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SpotInteractor.prefetchItems), object: nil)
    }
}
