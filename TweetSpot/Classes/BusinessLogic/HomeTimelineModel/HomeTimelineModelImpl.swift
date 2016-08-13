//
//  HomeTimelineModelImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class HomeTimelineModelImpl: NSObject, HomeTimelineModel {
    
    let twitterDAO: TwitterDAO
    
    init(twitterDAO: TwitterDAO) {
        self.twitterDAO = twitterDAO
        super.init()
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
        twitterDAO.getHomeTweets(maxId: nil, minId: homeLineTweets.first?.id, count: 10, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            strongSelf.completeWithLoadingDirection(.Forward)
            if dtos.count > 0 {
                strongSelf.homeLineTweets = dtos + strongSelf.homeLineTweets
            }
            success?(dtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            strongSelf.completeWithLoadingDirection(.Backward)
            error?(err)
        }
    }
    
    
    func loadBackward(success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?) {
        if !proceedWithLoadingDirection(.Backward) {
            return
        }
        let count = homeLineTweets.count > 0 ? 11 : 10
        twitterDAO.getHomeTweets(maxId: homeLineTweets.last?.id, minId: nil, count: count, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            strongSelf.completeWithLoadingDirection(.Backward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.first == strongSelf.homeLineTweets.last) {
                    resultDtos = Array(dtos[1...dtos.count - 1])
                }
                strongSelf.homeLineTweets += resultDtos
            }
            success?(resultDtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            strongSelf.completeWithLoadingDirection(.Backward)
            error?(err)
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