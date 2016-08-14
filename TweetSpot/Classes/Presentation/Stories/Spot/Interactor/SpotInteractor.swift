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
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "HH:mm dd.MM.yy"
        super.init()
    }
    
    func requestIfNeedToShowAvatars() {
        output.avatarsDisplay(required: self.settingsSvc.shouldDisplayUserAvatarsOnSpot)
    }
    
    func sessionCloseRequested() {
        session.closeSession()
    }
    
    func loadForwardRequested() {
        homeTimelineModel.loadForward({ (dtos) in
            var result: [SpotTweetItem] = []
            for dto in dtos {
                let item = SpotTweetItem(formattedPostDate: self.dateFormatter.stringFromDate(dto.creationDate),
                    text: dto.text,
                    userName: dto.userName,
                    screenName: dto.screenName)
                self.promiseImageLoad(item, urlString: dto.avatarUrlStr)
                result.append(item)
            }
            self.output.forwardItemsLoaded(result)
        }) { (error) in
            self.output.forwardProgressUpdated(enabled: false)
            log.debug("Error while loading forward")
        }
    }
    
    func loadBackwardRequested() {
        homeTimelineModel.loadBackward({ (dtos) in
            var result: [SpotTweetItem] = []
            for dto in dtos {
                let item = SpotTweetItem(formattedPostDate: self.dateFormatter.stringFromDate(dto.creationDate),
                    text: dto.text,
                    userName: dto.userName,
                    screenName: dto.screenName)
                self.promiseImageLoad(item, urlString: dto.avatarUrlStr)
                result.append(item)
            }
            self.output.backwardItemsLoaded(result)            
        }) { (error) in
            self.output.backwardProgressUpdated(enabled: false)
            log.debug("Error while loading backward")
        }
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
}
