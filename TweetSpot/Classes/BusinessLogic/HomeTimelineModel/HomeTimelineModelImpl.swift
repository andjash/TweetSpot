//
//  HomeTimelineModelImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class HomeTimelineModelImpl: NSObject, HomeTimelineModel {
    
    weak var session: TwitterSession?
    
    let twitterDAO: TwitterDAO
    var timelineStorage: HomeTimelineStorage? {
        didSet {
            loadingDirection = .Both
            timelineStorage?.restore({[weak self] (dtos) in
                guard let sself = self else { return }
                sself.homeLineTweets = dtos
                sself.loadingDirection = .None
            })
        }
    }
    
    init(twitterDAO: TwitterDAO) {
        self.twitterDAO = twitterDAO
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTimelineModelImpl.sessionStateChanged),
                                                         name: TwitterSessionConstants.stateChangedNotificaton, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var homeLineTweets: [TweetDTO] = [] {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(HomeTimelineModelConstants.timeLineChangedNotification,
                                                                      object: self,
                                                                      userInfo: nil)
        }
    }
    
    var loadingDirection: HomeTimelineModelLoadingDirection = .None {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(HomeTimelineModelConstants.loadingDirectionChangedNotification,
                                                                      object: self,
                                                                      userInfo: [HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey : oldValue.rawValue,
                                                                                 HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey : loadingDirection.rawValue])
        }
    }
    
    func loadForward(success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?) {
        if !proceedWithLoadingDirection(.Forward) {
            return
        }
        let count = homeLineTweets.count > 0 ? 200 : 20
        twitterDAO.getHomeTweets(maxId: nil, minId: homeLineTweets.first?.id, count: count, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .Opened { return }
            
            strongSelf.completeWithLoadingDirection(.Forward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.last == strongSelf.homeLineTweets.last) {
                    resultDtos = Array(dtos[0...dtos.count - 2])
                    //TODO: there are more tweets on server, load them
                }
                strongSelf.timelineStorage?.storeItemsAbove(dtos)
                strongSelf.homeLineTweets = resultDtos + strongSelf.homeLineTweets
            }
            success?(dtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .Opened { return }
            
            strongSelf.completeWithLoadingDirection(.Backward)
            error?(err)
        }
    }
    
    
    func loadBackward(success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?) {
        if !proceedWithLoadingDirection(.Backward) {
            return
        }
    
        twitterDAO.getHomeTweets(maxId: homeLineTweets.last?.id, minId: nil, count: 20, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .Opened { return }
            
            strongSelf.completeWithLoadingDirection(.Backward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.first == strongSelf.homeLineTweets.last) {
                    resultDtos = Array(dtos[1...dtos.count - 1])
                }
                strongSelf.timelineStorage?.storeItemsBelow(dtos)
                strongSelf.homeLineTweets += resultDtos
            }
            success?(resultDtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .Opened { return }
            
            strongSelf.completeWithLoadingDirection(.Backward)
            error?(err)
        }
    }
    
    func sessionStateChanged() {
        if self.session?.state == .Closed {
            homeLineTweets = []
            twitterDAO.cancelAllRequests()
        }
    }
    
    // MARK: Private
    
    func proceedWithLoadingDirection(direction: HomeTimelineModelLoadingDirection) -> Bool {
        if direction == .Forward {
            switch loadingDirection {
            case .Forward, .Both:
                log.debug("Trying to load forward while forward loading already in progress")
                return false
            case .None:
                loadingDirection = .Forward
            case .Backward:
                loadingDirection = .Both
            }
            return true
        } else {
            switch loadingDirection {
            case .Backward, .Both:
                log.debug("Trying to load backward while backward loading already in progress")
                return false
            case .None:
                loadingDirection = .Backward
            case .Forward:
                loadingDirection = .Both
            }
            return true
        }
    }
    
    func completeWithLoadingDirection(direction: HomeTimelineModelLoadingDirection) {
        if direction == .Forward {
            switch loadingDirection {
            case .Both:
                loadingDirection = .Backward
            default:
                loadingDirection = .None
            }
        } else {
            switch loadingDirection {
            case .Both:
                loadingDirection = .Forward
            default:
                loadingDirection = .None
            }
        }
    }
}
